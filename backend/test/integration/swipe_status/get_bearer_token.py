from urllib.parse import urlencode


def get_bearer_token(email: str, pwd: str, client):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"}
    data_encoded = urlencode({"username": f"{email}", "password": f"{pwd}"})
    return client.post("/users/login", headers=headers, data=data_encoded)
