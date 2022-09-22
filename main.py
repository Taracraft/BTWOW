# -*- coding: iso-8859-1 -*-
import asyncio
import logging.handlers
import discord

# Vars
intents = discord.Intents.all()
intents.members = True
intents.messages = True
intents.presences = True
client = discord.Client(intents=discord.Intents.all())
g = client.get_guild(904846660256022579)

# logging
logger = logging.getLogger('discord')
logger.setLevel(logging.DEBUG)
logging.getLogger('discord.http').setLevel(logging.INFO)
handler = logging.handlers.RotatingFileHandler(
    filename='discord.log',
    encoding='utf-8',
    maxBytes=32 * 1024 * 1024,  # 32 MiB
    backupCount=5,  # Rotate through 5 files
)
dt_fmt = '%Y-%m-%d %H:%M:%S'
formatter = logging.Formatter('[{asctime}] [{levelname:<8}] {name}: {message}', dt_fmt, style='{')
handler.setFormatter(formatter)
logger.addHandler(handler)


# presence
@client.event
async def status_task():
    while True:
        await client.change_presence(activity=discord.Game('https://www.bad-timing.eu'),
                                     status=discord.Status.online)
        await asyncio.sleep(5)
        await client.change_presence(activity=discord.Game('Welcome-Bot'), status=discord.Status.online)
        await asyncio.sleep(5)


# Rollen-zuweisung neue Mitglieder
@client.event
async def on_member_join(member: discord.Member):
    role = discord.utils.get(member.guild.roles, name="Member")
    channel = client.get_channel(905056217595002891)
    if member.guild.id == 904846660256022579:
        await member.add_roles(role)
        await channel.send(
            f'**Hey! {member.name}**\n Willkommen auf dem Discord Server von Bad-Timing! \n Viel Spa߸!')


# Commands
@client.event
async def on_message(message):
    global g

    if message.author.bot:
        return
    if message.content.lower() == "!help":
        await message.channel.send('**Hilfe zum BT-Bot**\n\n'
                                   '$help zeigt diese Hilfe an.')
# Skript Start
def main():
    @client.event
    async def on_ready():
        global g
        print("Bot is ready!")
        print("Logged in as: " + client.user.name)
        print("Bot ID: " + str(client.user.id))
        for guild in client.guilds:
            print("Connected to server: {}".format(guild))
        print("------")
        client.loop.create_task(status_task())

# Start
if __name__ == '__main__':
    main()

# Bot Token & Run
client.run('')