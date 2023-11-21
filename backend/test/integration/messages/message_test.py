from datetime import datetime, timedelta

import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session

from backend.models.conversation import Conversation
from backend.models.message import Message
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session

from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.test.integration.fixtures import add_test_users, login, authorized_call


def test_get_messages_conversation_not_found(client: TestClient, session: Session):
    add_test_users(session)
    token = login(client, "alfa.alfonson@email.com", "pass1")
    response = authorized_call(client, token, lambda c: c.get, "/messages/1")

    assert(response.status_code == 404)


def test_get_messages_unauthorized_users(client: TestClient, session: Session):
    add_test_users(session)
    token = login(client, "alfa.alfonson@email.com", "pass1")
    session.add(Conversation(user1_id=2, user2_id=3))
    session.commit()
    response = authorized_call(client, token, lambda c: c.get, "/messages/1")

    assert(response.status_code == 401)


def test_get_messages_conversation_owner(client: TestClient, session: Session):
    add_test_users(session)
    token = login(client, "alfa.alfonson@email.com", "pass1")
    session.add(Conversation(user1_id=1, user2_id=2))
    session.commit()
    response = authorized_call(client, token, lambda c: c.get, "/messages/1")

    assert(response.status_code == 200)


def test_get_messages_conversation_recipient(client: TestClient, session: Session):
    add_test_users(session)
    token = login(client, "alfa.alfonson@email.com", "pass1")
    session.add(Conversation(user1_id=2, user2_id=1))
    session.commit()

    response = authorized_call(client, token, lambda c: c.get, "/messages/1")

    assert (response.status_code == 200)


def test_get_messages_return_earliest_messages(client: TestClient, session: Session):
    add_test_users(session)
    token = login(client, "alfa.alfonson@email.com", "pass1")

    c = Conversation(user1_id=1, user2_id=2)

    session.add(c)
    session.commit()
    session.refresh(c)

    m1 = Message(conversation_id=c.id, sender_id=1, receiver_id=2, timestamp=datetime.now() - timedelta(seconds=10), message="old")
    m2 = Message(conversation_id=c.id, sender_id=1, receiver_id=2, timestamp=datetime.now(), message="newest")

    session.add(m1)
    session.add(m2)
    session.commit()

    response = authorized_call(client, token, lambda c: c.get, "/messages/1")

    assert (response.status_code == 200)
    print(response.json())
    assert (response.json())
