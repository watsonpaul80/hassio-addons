from telethon.sync import TelegramClient

# Replace these with your actual API credentials
api_id = os.getenv('TELEGRAM_API_ID')
api_hash = os.getenv('TELEGRAM_API_HASH')

# Session file will be saved in /app/sessions
session_file = '/app/sessions/telegram_session'

# Initialize the Telegram client with the session file
client = TelegramClient(session_file, api_id, api_hash)

async def get_groups():
    # Start the client
    await client.start()
    
    # Get dialogs (all chats)
    dialogs = await client.get_dialogs()

    # Print the chat IDs and names of all groups and channels
    for dialog in dialogs:
        if dialog.is_group or dialog.is_channel:
            print(f"Name: {dialog.name}, ID: {dialog.id}")

# Run the script
with client:
    client.loop.run_until_complete(get_groups())
