using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

#nullable disable

namespace PiperChatWebApiData.Models
{
    public partial class ChatUser
    {
        public ChatUser()
        {
            MessageReceivers = new HashSet<Message>();
            MessageSenders = new HashSet<Message>();
        }

        public int ChatUserId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Avatar { get; set; }
        [NotMapped]
        public string PublicKey { get; set; }
        public virtual ICollection<Message> MessageReceivers { get; set; }
        public virtual ICollection<Message> MessageSenders { get; set; }
    }
}
