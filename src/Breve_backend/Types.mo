module {
    public type Message = {
        content : Text;
        sendTime : Int;
        senderId : Text;
    };
    
    public type Messages = {
        messages : [Message];
        totalEntries : Nat;
        page : Nat;
        hasMore : Bool; // Added to help with pagination UI
    };
    
    public type SendMessageDTO = {
        to : Text;
        message : Text;
        from : Text;
    };
    
    public type Error = {
        #TooLong;
        #InvalidData;
        #EmptyMessage;
        #InvalidSender;
        #InvalidRecipient;
    };
}