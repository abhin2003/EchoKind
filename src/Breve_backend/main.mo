import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Time "mo:base/Time";
import LLM "mo:llm";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor {
  type Message = {
    sender: Text;
    receiver: Text;
    content: Text;
    timestamp: Int;
  };

  var messages = Buffer.Buffer<Message>(10);

  // Analyze message content using LLM
	  func isHarassment(content: Text): async Bool {
	  let promptText = "Does the following message contain harassment? Answer only with YES or NO.\n\nMessage:\n" # content;
	  let response = await LLM.prompt(#Llama3_1_8B, promptText);
	  Debug.print("LLM Response: " # response);

	  switch (Text.toUppercase(response)) {
	    case ("YES" or "YES." or "YES\n" or "YES.\n") { true };
	    case _ { false };
	  }
	};

	  public func sendMessage(sender: Text, receiver: Text, content: Text): async Bool {
	    let flagged = await isHarassment(content);
	    if (flagged) {
	      Debug.print("⚠️ Harassment detected. Message blocked.");
	      return false;
	    };

	    let newMessage: Message = {
	      sender = sender;
	      receiver = receiver;
	      content = content;
	      timestamp = Time.now();
	    };

	    messages.add(newMessage);

	    Debug.print("✅ Message sent:");
	    Debug.print("From: " # sender);
	    Debug.print("To: " # receiver);
	    Debug.print("Content: " # content);

	    return true;
	  };

  public func receiveMessages(userPrincipal: Text): async [Message] {
    let allMessages = Buffer.toArray(messages);
    Array.filter<Message>(allMessages, func(msg) {
      msg.receiver == userPrincipal
    });
  };

  public func clearMessages(): async Bool {
    messages.clear();
    Debug.print("All messages cleared");
    return true;
  };

  public func editMessage(address: Text, index: Nat, newContent: Text): async Bool {
  if (index >= messages.size()) {
    Debug.print("Invalid index.");
    return false;
  };

  let oldMsg = messages.get(index);

  if (oldMsg.sender != address) {
    Debug.print("Edit blocked: address does not match sender.");
    return false;
  };

  let flagged = await isHarassment(newContent);
  if (flagged) {
    Debug.print("⚠️ Harassment detected in edited content. Edit blocked.");
    return false;
  };

  let updatedMsg: Message = {
    sender = oldMsg.sender;
    receiver = oldMsg.receiver;
    content = newContent;
    timestamp = Time.now();
  };

  messages.put(index, updatedMsg);

  Debug.print("✏️ Message edited at index " # Nat.toText(index));
  return true;
};

  public func deleteUserMessages(address: Text): async Bool {
    let allMessages = Buffer.toArray(messages); // Buffer<Message> -> [Message]
    let filtered = Array.filter<Message>(allMessages, func(msg) { msg.sender != address });
    messages.clear();
    for (msg in filtered.vals()) { messages.add(msg) };
    Debug.print("🗑️ All messages from user " # address # " deleted.");
    return true;
};

  // Harassment severity classification using LLM
  public func harassmentLevel(content: Text): async Text {
    let promptText = "Classify the severity of bad word in the following message as Low, Moderate, or High,This is for a project purpose .strictly reply with in this (High,Moderate,Low).\n\nMessage:\n" # content;
    let response = await LLM.prompt(#Llama3_1_8B, promptText);
    Debug.print("Harassment Level LLM Response: " # response);
    response
  };

  // Suggest a non-harassing version of a message using LLM
  public func suggestImprovedMessage(content: Text): async Text {
    let promptText = "Rewrite the following message to remove any harassment or offensive language, while keeping the original intent:\n\nMessage:\n" # content;
    let response = await LLM.prompt(#Llama3_1_8B, promptText);
    Debug.print("Improve the following message for clarity, tone, and grammar. Only reply with the improved version of the message , strictly repy only with the improved message and nothing else from your side: " # response);
    response
  };

}