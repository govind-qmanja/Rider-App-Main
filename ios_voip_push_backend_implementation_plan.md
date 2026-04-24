# iOS Native VoIP Push (C# Backend) Implementation Guide

To guarantee that iOS devices wake up immediately and show the CallKit incoming order screen, **you cannot rely on standard FCM data messages**. Apple severely restricts background processing for battery saving. Standard Android devices use FCM, but iOS devices should use **Apple Push Notification Service (APNs) VoIP pushes**. APNs VoIP skips all battery limits, waking up the phone instantly to show the full-screen CallKit screen.

---

## 1. Requirements from your Flutter App

You must capture the iOS native **VoIP Push Token** (which is entirely different from the standard Firebase Cloud Messaging token). The `flutter_callkit_incoming` package gets this token automatically. You need to save this specifically as the `voipToken` in your database via your API.

In your Flutter app (`main.dart` or your login flow):

```dart
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

// Retrieve the native Apple VoIP push token
var voipToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();

// TODO: Send this 'voipToken' to your backend API to be saved with the rider's profile.
```

---

## 2. C# Backend Implementation

The most modern and reliable way to connect to Apple's Push servers is using `HttpClient` with `.NET` over HTTP/2 and Apple's `.p8` Authentication Tokens.

### Step A: Install Nuget Packages
You need the JWT package to generate the Apple Auth Token securely using your `.p8` file.
```bash
dotnet add package System.IdentityModel.Tokens.Jwt
```

### Step B: Create the C# VoIP Service

Create a new file `ApnsVoipPushService.cs` in your C# backend:

```csharp
using System;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Collections.Generic;

public class ApnsVoipPushService
{
    private readonly HttpClient _httpClient;
    
    // ==========================================
    // REPLACE THESE WITH YOUR APPLE DEVELOPER CREDENTIALS
    // ==========================================
    private readonly string _teamId = "YOUR_APPLE_TEAM_ID"; // E.g., "AB1234567C"
    
    // Note: VoIP appends ".voip" to your bundle identifier automatically
    private readonly string _bundleId = "com.qmanja.foods.riders"; 
    
    private readonly string _keyId = "YOUR_P8_KEY_ID"; // E.g., "1A2B3C4D5E"
    
    // Path or string of your AuthKey_1A2B3C4D5E.p8 file downloaded from Apple Developer Portal
    private readonly string _p8PrivateKey = @"-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGBy... (YOUR EXACT P8 KEY CONTENT BETWEEN THESE HEADERS) ...
-----END PRIVATE KEY-----";

    public ApnsVoipPushService()
    {
        _httpClient = new HttpClient();
        // APNs REQUIRES HTTP/2 connection
        _httpClient.DefaultRequestVersion = new Version(2, 0); 
    }

    /// <summary>
    /// Sends a VoIP Push directly to an Apple Device
    /// </summary>
    public async Task<bool> SendVoIPPushAsync(string deviceVoipToken, string orderId, string restaurantName, decimal amount)
    {
        // 1. Apple's Production Endpoint for VoIP
        var url = $"https://api.push.apple.com/3/device/{deviceVoipToken}";

        // 2. Generate Apple Auth Token
        var jwtToken = GenerateApnsJwtToken();

        // 3. Create Request
        var request = new HttpRequestMessage(HttpMethod.Post, url);
        request.Headers.Add("authorization", $"bearer {jwtToken}");
        
        // Ensure this targets VoIP! This forces iOS to bypass battery optimization.
        request.Headers.Add("apns-topic", $"{_bundleId}.voip"); 
        request.Headers.Add("apns-push-type", "voip");
        request.Headers.Add("apns-priority", "10"); // Highest priority (wake immediately)

        // 4. Create the JSON Payload for CallKit
        var payload = new
        {
            aps = new
            {
                // Must be present for VoIP wakeups
                content_available = 1 
            },
            
            // The extra data your Flutter app parses using message.data
            order_id = orderId,
            restaurant = restaurantName,
            price = amount.ToString("0.00"),
            type = "order"
        };

        var jsonContent = JsonSerializer.Serialize(payload);
        request.Content = new StringContent(jsonContent, System.Text.Encoding.UTF8, "application/json");

        // 5. Send to Apple Push Notification Service (APNs)
        try
        {
            var response = await _httpClient.SendAsync(request);
            if (response.IsSuccessStatusCode)
            {
                Console.WriteLine($"[APNs] VoIP Push sent successfully to {deviceVoipToken}");
                return true;
            }
            else
            {
                var errorResponse = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"[APNs] Error sending VoIP push: {response.StatusCode} - {errorResponse}");
                return false;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[APNs] Exception while sending VoIP push: {ex.Message}");
            return false;
        }
    }

    /// <summary>
    /// Generates a valid Apple JWT using the .p8 private key
    /// </summary>
    private string GenerateApnsJwtToken()
    {
        var ecdsa = ECDsa.Create();
        
        // Clean the string (remove headers/footers/newlines)
        var privateKeyBase64 = _p8PrivateKey
            .Replace("-----BEGIN PRIVATE KEY-----", "")
            .Replace("-----END PRIVATE KEY-----", "")
            .Replace("\r", "").Replace("\n", "");

        ecdsa.ImportPkcs8PrivateKey(Convert.FromBase64String(privateKeyBase64), out _);

        var securityKey = new ECDsaSecurityKey(ecdsa) { KeyId = _keyId };
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.EcdsaSha256);

        var header = new JwtHeader(credentials);
        var payload = new JwtPayload(
            issuer: _teamId,
            audience: null,
            claims: new List<System.Security.Claims.Claim>(),
            notBefore: null,
            expires: null,
            issuedAt: DateTime.UtcNow
        );

        var token = new JwtSecurityToken(header, payload);
        var tokenHandler = new JwtSecurityTokenHandler();
        
        return tokenHandler.WriteToken(token);
    }
}
```

---

## 3. Modifying Your Backend Dispatch Logic

When a new order needs to be dispatched to a rider, simply check which OS the rider is using and route the push notification accordingly:

```csharp
// Example dispatch logic when assigning an order
public async Task DispatchOrderToRider(Rider rider, Order order)
{
    if (rider.OsType == "Android")
    {
        // For Android: Use your existing Firebase/AWS FCM HTTP logic!
        await _fcmService.SendFcmPushAsync(rider.FcmToken, order); 
    }
    else if (rider.OsType == "iOS")
    {
        // For iOS: Bypass FCM instantly and hit APNs directly with the VoIP Token!
        await _apnsVoipService.SendVoIPPushAsync(
            rider.VoipToken, 
            order.Id.ToString(), 
            order.Restaurant.Name, 
            order.TotalAmount
        );
    }
}
```

### Why iOS uses a different path: 
FCM pushes work perfectly on Android because Google owns the operating system. On iOS, Google has to pass the FCM message to Apple, and Apple actively throttles full-screen visual wakeups from third-party services. Passing the message directly to Apple's VoIP Push servers strictly avoids this bottleneck.
