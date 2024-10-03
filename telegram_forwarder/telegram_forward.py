import os
from telethon import TelegramClient, events

# Fetch API credentials from Home Assistant configuration (environment variables)
api_id = os.getenv('TELEGRAM_API_ID')
api_hash = os.getenv('TELEGRAM_API_HASH')

# Session file will be saved in /app/sessions
session_file = '/app/sessions/telegram_session'

# Initialize the Telegram client with the session file
client = TelegramClient(session_file, api_id, api_hash)

# Define the source and destination group chat IDs (environment variables for flexibility)
source_group = os.getenv('SOURCE_GROUP_ID')
destination_group = os.getenv('DESTINATION_GROUP_ID')

@client.on(events.NewMessage(chats=int(source_group)))
async def forward_message(event):
    # Forward the message to the destination group
    await client.forward_messages(int(destination_group), event.message)

# Start the client
async def main():
    await client.start()
    print("Telegram client started!")
    await client.run_until_disconnected()

# Run the main function
with client:
    client.loop.run_until_complete(main())
