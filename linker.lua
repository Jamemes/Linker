local data = ChatManager.send_message
function ChatManager:send_message(channel_id, sender, message)

	data(self, channel_id, sender, message)
end