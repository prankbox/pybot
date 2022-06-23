import json
import os
import sys
from datetime import datetime

sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "./vendored"))

import requests

TOKEN = os.environ['TELEGRAM_TOKEN']
BASE_URL = "https://api.telegram.org/bot{}".format(TOKEN)

def get_data():
	req = requests.get("https://yobit.net/api/3/ticker/btc_usd")
	response = req.json()
	sell_price = response["btc_usd"]["sell"]
	return f"{datetime.now().strftime('%Y-%m-%d %H-%M')}\nSell BTC price: {sell_price}"
	
def bot(event, context):
	try:
		price = get_data()
		data = json.loads(event["body"])
		message = str(data["message"]["text"])
		chat_id = data["message"]["chat"]["id"]
		first_name = data["message"]["chat"]["first_name"]

		response = "Привет, {}, today {}".format(first_name,price)
		

		data = {"text": response.encode("utf8"), "chat_id": chat_id}
		url = BASE_URL + "/sendMessage"
		requests.post(url, data)

	except Exception as e:
		print(e)

	return {"statusCode": 200}
