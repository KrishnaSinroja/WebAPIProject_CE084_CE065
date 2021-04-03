using PiperChatWebApiData.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace PiperChatWebApiData.Interfaces
{
    public interface IChatUser
    {
        public List<ChatUser> GetChatUsers();
        public ChatUser GetChatUser(int chatUserId);
        public void AddChatUser(ChatUser chatUser);
        public ChatUser LoginUser(ChatUser chatUser);

    }
}
