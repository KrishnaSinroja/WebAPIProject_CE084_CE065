using PiperChatWebApiData.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace PiperChatWebApiData.Interfaces
{
    public interface IChatMessage
    {
        public List<Message> GetChatMessageOfUser(int userId);
        public Message AddChatMessage(Message chatMessage);
 
    }
}
