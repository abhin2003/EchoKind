import React, { useState } from 'react';

const App = () => {
  // State management
  const [messages, setMessages] = useState([]);
  const [senderPrincipal, setSenderPrincipal] = useState('');
  const [receiverPrincipal, setReceiverPrincipal] = useState('');
  const [messageContent, setMessageContent] = useState('');
  const [userPrincipal, setUserPrincipal] = useState('');
  const [userMessages, setUserMessages] = useState([]);
  const [allMessages, setAllMessages] = useState([]);
  const [sendStatus, setSendStatus] = useState('');
  const [receiveStatus, setReceiveStatus] = useState('');

  // Helper function to show temporary status
  const showStatus = (setStatusFunc, message, duration = 3000) => {
    setStatusFunc(message);
    setTimeout(() => setStatusFunc(''), duration);
  };

  // Send message function
  const sendMessage = async () => {
    if (!senderPrincipal.trim() || !receiverPrincipal.trim() || !messageContent.trim()) {
      showStatus(setSendStatus, 'Please fill in all fields');
      return;
    }

    const newMessage = {
      sender: senderPrincipal.trim(),
      receiver: receiverPrincipal.trim(),
      content: messageContent.trim(),
      timestamp: Date.now()
    };

    // Add to messages array
    setMessages(prev => [...prev, newMessage]);
    
    // Clear message content
    setMessageContent('');
    
    // Show success status
    showStatus(setSendStatus, 'Message sent successfully!');
    
    console.log('Message sent:', newMessage);
    
    // Here you would call your Motoko canister
    // Example: await canister.sendMessage(senderPrincipal, receiverPrincipal, messageContent);
  };

  // Receive messages function
  const receiveMessages = async () => {
    if (!userPrincipal.trim()) {
      showStatus(setReceiveStatus, 'Please enter your principal ID');
      return;
    }

    // Filter messages for this user
    const filteredMessages = messages.filter(msg => msg.receiver === userPrincipal.trim());
    
    setUserMessages(filteredMessages);
    
    if (filteredMessages.length === 0) {
      showStatus(setReceiveStatus, 'No messages found for this user');
    } else {
      showStatus(setReceiveStatus, `Found ${filteredMessages.length} message(s)`);
    }

    console.log('Messages retrieved for user:', userPrincipal);
    
    // Here you would call your Motoko canister
    // Example: const userMsgs = await canister.receiveMessages(userPrincipal);
  };

  // Get all messages function
  const getAllMessages = async () => {
    setAllMessages([...messages]);
    console.log('All messages retrieved:', messages);
    
    // Here you would call your Motoko canister
    // Example: const allMsgs = await canister.getAllMessages();
  };

  // Clear all messages function
  const clearAllMessages = async () => {
    setMessages([]);
    setUserMessages([]);
    setAllMessages([]);
    showStatus(setSendStatus, 'All messages cleared');
    
    console.log('All messages cleared');
    
    // Here you would call your Motoko canister
    // Example: await canister.clearMessages();
  };

  // Format timestamp
  const formatTimestamp = (timestamp) => {
    return new Date(timestamp).toLocaleString();
  };

  // Handle Enter key press
  const handleKeyPress = (e, action) => {
    if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') {
      e.preventDefault();
      action();
    }
  };

  return (
    <div className="container">
      <div className="header">
        <h1>📱 Motoko Messaging</h1>
        <p>Simple blockchain messaging system</p>
      </div>

      <div className="content">
        <div className="info-box">
          <h3>📋 How to use:</h3>
          <p>
            1. Enter your principal ID and the recipient's principal ID<br />
            2. Type your message and click "Send Message"<br />
            3. Use "Receive Messages" to check messages sent to you
          </p>
        </div>

        {/* Send Message Section */}
        <div className="section">
          <h2>📤 Send Message</h2>
          <div className="form-group">
            <label htmlFor="senderPrincipal">Your Principal ID:</label>
            <input
              type="text"
              id="senderPrincipal"
              value={senderPrincipal}
              onChange={(e) => setSenderPrincipal(e.target.value)}
              placeholder="Enter your principal ID"
              onKeyPress={(e) => handleKeyPress(e, () => document.getElementById('receiverPrincipal').focus())}
            />
          </div>
          <div className="form-group">
            <label htmlFor="receiverPrincipal">Receiver's Principal ID:</label>
            <input
              type="text"
              id="receiverPrincipal"
              value={receiverPrincipal}
              onChange={(e) => setReceiverPrincipal(e.target.value)}
              placeholder="Enter receiver's principal ID"
              onKeyPress={(e) => handleKeyPress(e, () => document.getElementById('messageContent').focus())}
            />
          </div>
          <div className="form-group">
            <label htmlFor="messageContent">Message:</label>
            <textarea
              id="messageContent"
              value={messageContent}
              onChange={(e) => setMessageContent(e.target.value)}
              placeholder="Type your message here..."
            />
          </div>
          <button className="btn" onClick={sendMessage}>
            Send Message
          </button>
          {sendStatus && (
            <div className={`status ${sendStatus.includes('successfully') ? 'success' : 'error'}`}>
              {sendStatus}
            </div>
          )}
        </div>

        {/* Receive Messages Section */}
        <div className="section">
          <h2>📥 Receive Messages</h2>
          <div className="form-group">
            <label htmlFor="userPrincipal">Your Principal ID:</label>
            <input
              type="text"
              id="userPrincipal"
              value={userPrincipal}
              onChange={(e) => setUserPrincipal(e.target.value)}
              placeholder="Enter your principal ID"
              onKeyPress={(e) => handleKeyPress(e, receiveMessages)}
            />
          </div>
          <button className="btn" onClick={receiveMessages}>
            Get My Messages
          </button>
          {receiveStatus && (
            <div className={`status ${receiveStatus.includes('Found') || receiveStatus.includes('cleared') ? 'success' : 'error'}`}>
              {receiveStatus}
            </div>
          )}
          {userMessages.length > 0 && (
            <div className="messages">
              {userMessages.map((msg, index) => (
                <div key={index} className="message-item">
                  <div className="message-sender">From: {msg.sender}</div>
                  <div className="message-content">{msg.content}</div>
                  <div className="message-time">{formatTimestamp(msg.timestamp)}</div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* View All Messages Section */}
        <div className="section">
          <h2>📋 All Messages (Debug)</h2>
          <button className="btn" onClick={getAllMessages}>
            View All Messages
          </button>
          <button className="btn btn-danger" onClick={clearAllMessages}>
            Clear All
          </button>
          {allMessages.length > 0 && (
            <div className="messages">
              {allMessages.map((msg, index) => (
                <div key={index} className="message-item">
                  <div className="message-sender">
                    From: {msg.sender} → To: {msg.receiver}
                  </div>
                  <div className="message-content">{msg.content}</div>
                  <div className="message-time">{formatTimestamp(msg.timestamp)}</div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default App;