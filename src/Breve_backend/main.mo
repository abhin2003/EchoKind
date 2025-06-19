import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Time "mo:base/Time";

actor {
  // Message type definition
  type Message = {
    sender: Text;
    receiver: Text;
    content: Text;
    timestamp: Int;
  };

  // Store all messages in a buffer
  var messages = Buffer.Buffer<Message>(10);

  // Send message function - takes sender, receiver, and message content
  public func sendMessage(sender: Text, receiver: Text, content: Text): async Bool {
    let newMessage: Message = {
      sender = sender;
      receiver = receiver;
      content = content;
      timestamp = Time.now();
    };
    
    messages.add(newMessage);
    
    Debug.print("Message sent:");
    Debug.print("From: " # sender);
    Debug.print("To: " # receiver);
    Debug.print("Content: " # content);
    
    return true;
  };

  // Receive messages function - takes user principal and returns their messages
  public func receiveMessages(userPrincipal: Text): async [Message] {
    let allMessages = Buffer.toArray(messages);
    
    // Filter messages where the user is the receiver
    let userMessages = Array.filter<Message>(allMessages, func(msg) {
      msg.receiver == userPrincipal
    });
    
    Debug.print("Retrieved " # debug_show(userMessages.size()) # " messages for user: " # userPrincipal);
    
    return userMessages;
  };

  // Get sent messages function - returns messages sent by a user
  public func getSentMessages(userPrincipal: Text): async [Message] {
    let allMessages = Buffer.toArray(messages);
    
    // Filter messages where the user is the sender
    let sentMessages = Array.filter<Message>(allMessages, func(msg) {
      msg.sender == userPrincipal
    });
    
    return sentMessages;
  };

  // Get all messages (for debugging)
  public func getAllMessages(): async [Message] {
    return Buffer.toArray(messages);
  };

  // Clear all messages (for testing)
  public func clearMessages(): async Bool {
    messages.clear();
    Debug.print("All messages cleared");
    return true;
  };
}