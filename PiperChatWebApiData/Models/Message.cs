using System;
using System.Collections.Generic;

#nullable disable

namespace PiperChatWebApiData.Models
{
    public partial class Message
    {
        public int MessageId { get; set; }
        public int SenderId { get; set; }
        public int ReceiverId { get; set; }
        public string Message1 { get; set; }
        public DateTime? MessageTime { get; set; }
        public string Avatar { get; set; }

        public virtual ChatUser Receiver { get; set; }
        public virtual ChatUser Sender { get; set; }
    }
}
