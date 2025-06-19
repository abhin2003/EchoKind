import Types "./Types";
import Text "mo:base/Text";
import Result "mo:base/Result";

module {
    let MAX_MESSAGE_LENGTH : Nat = 280;
    let MIN_MESSAGE_LENGTH : Nat = 1;
    
    public func validateMessage(text : Text) : Result.Result<(), Types.Error> {
        let messageLength = Text.size(text);
        
        if (messageLength < MIN_MESSAGE_LENGTH) {
            return #err(#EmptyMessage);
        };
        
        if (messageLength > MAX_MESSAGE_LENGTH) {
            return #err(#TooLong);
        };
        
        #ok(())
    };
    
    public func validatePrincipal(principalText : Text) : Result.Result<(), Types.Error> {
        if (Text.size(principalText) == 0) {
            return #err(#InvalidData);
        };
        // Add more principal validation logic here if needed
        #ok(())
    };
    
    public func validateSendMessageDTO(dto : Types.SendMessageDTO) : Result.Result<(), Types.Error> {
        switch (validateMessage(dto.message)) {
            case (#err(error)) return #err(error);
            case (#ok(_)) {};
        };
        
        switch (validatePrincipal(dto.from)) {
            case (#err(_)) return #err(#InvalidSender);
            case (#ok(_)) {};
        };
        
        switch (validatePrincipal(dto.to)) {
            case (#err(_)) return #err(#InvalidRecipient);
            case (#ok(_)) {};
        };
        
        #ok(())
    };
}