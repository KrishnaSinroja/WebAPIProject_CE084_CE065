using Microsoft.AspNetCore.SignalR;
using PiperChatWebApiData.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace PiperChatWebApiCore.Hubs
{
    public class ChatHub:Hub
    {
        static Dictionary<int, ChatUser> onlineUsers = new Dictionary<int, ChatUser>();
        static Dictionary<int, string> connectionIdS = new Dictionary<int, string>();
        public async Task UserConnected(string jsonString)
        {
            Console.WriteLine("User connected"+jsonString);
            await Clients.Caller.SendAsync("NewUserConnected", Newtonsoft.Json.JsonConvert.SerializeObject(onlineUsers));
            ChatUser chatUser = JsonSerializer.Deserialize<ChatUser>(jsonString);
            if (!onlineUsers.ContainsKey(chatUser.ChatUserId))
            {
                connectionIdS.Add(chatUser.ChatUserId, Context.ConnectionId);
                onlineUsers.Add(chatUser.ChatUserId, chatUser);
                await Clients.Others.SendAsync("NotifyToOthers", Newtonsoft.Json.JsonConvert.SerializeObject(chatUser));
            }
            
            //Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(onlineUsers));
            //Console.WriteLine(JsonSerializer.Serialize(onlineUsers));

        }
        public async Task UserDisconnected(string jsonString)
        {
            Console.WriteLine("User disconnceted" + jsonString);
            ChatUser chatUser = JsonSerializer.Deserialize<ChatUser>(jsonString);
            if (onlineUsers.ContainsKey(chatUser.ChatUserId))
            {
                connectionIdS.Remove(chatUser.ChatUserId);
                onlineUsers.Remove(chatUser.ChatUserId);
                await Clients.Others.SendAsync("NotifyToOthersDisconnect", Newtonsoft.Json.JsonConvert.SerializeObject(chatUser));
            }

        }

        public async Task SendMessage(string jsonString)
        {
            Console.WriteLine("Recieved message" + jsonString);
            Message message = Newtonsoft.Json.JsonConvert.DeserializeObject<Message>(jsonString);
            string connectId = connectionIdS[message.ReceiverId];
            await Clients.Client(connectId).SendAsync("ReceiveMessage", jsonString);
        }
    }
}
