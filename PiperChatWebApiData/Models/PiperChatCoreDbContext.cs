using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace PiperChatWebApiData.Models
{
    public partial class PiperChatCoreDbContext : DbContext
    {
        public PiperChatCoreDbContext()
        {
        }

        public PiperChatCoreDbContext(DbContextOptions<PiperChatCoreDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<ChatUser> ChatUsers { get; set; }
        public virtual DbSet<Message> Messages { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=PiperChatCoreDb;Integrated Security=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "SQL_Latin1_General_CP1_CI_AS");

            modelBuilder.Entity<ChatUser>(entity =>
            {
                entity.ToTable("ChatUser");

                entity.Property(e => e.Avatar)
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.Email)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Name)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Password)
                    .HasMaxLength(3000)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Message>(entity =>
            {
                entity.ToTable("Message");

                entity.Property(e => e.Avatar)
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.Message1)
                    .IsRequired()
                    .HasMaxLength(3000)
                    .IsUnicode(false)
                    .HasColumnName("Message");

                entity.Property(e => e.MessageTime).HasColumnType("datetime");

                entity.HasOne(d => d.Receiver)
                    .WithMany(p => p.MessageReceivers)
                    .HasForeignKey(d => d.ReceiverId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Message_ToTable");

                entity.HasOne(d => d.Sender)
                    .WithMany(p => p.MessageSenders)
                    .HasForeignKey(d => d.SenderId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Message_ToTable_1");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
