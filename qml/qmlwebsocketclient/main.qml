import QtQuick 2.15
import QtWebSockets 1.0

Rectangle {
    width: 640
    height: 360

    property bool welcome1Clicked: false
    property bool welcome2Clicked: false

    WebSocket {
        id: socket
        url: "ws://192.168.43.1:8083/websocket"
        onTextMessageReceived: function(message) {
            messageBox.text = messageBox.text + "\nReceived message: " + message
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
                if (welcome1Clicked)
                    socket.sendTextMessage("前进");
                welcome1Clicked = false;
            } else if (socket.status == WebSocket.Closed) {
                messageBox.text += "\nSocket closed"
            }
        }
        active: false
    }

    WebSocket {
        id: secureWebSocket
        url: "ws://192.168.43.1:8083/websocket"
        onTextMessageReceived: function(message) {
            messageBox.text = messageBox.text + "\nReceived secure message: " + message
        }
        onStatusChanged: {
            if (secureWebSocket.status == WebSocket.Error) {
                console.log("Error: " + secureWebSocket.errorString)
            } else if (secureWebSocket.status == WebSocket.Open) {
                if (welcome2Clicked)
                    secureWebSocket.sendTextMessage("后退");
                welcome2Clicked = false;
            } else if (secureWebSocket.status == WebSocket.Closed) {
                messageBox.text += "\nSecure socket closed"
            }
        }
        active: false
    }

    Text {
        id: messageBox
        text: socket.status == WebSocket.Open ? qsTr("Sending...") : qsTr("前进")
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            welcome1Clicked = true;
            socket.active = !socket.active;
        }
    }

    Text {
        text: "后退"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: messageBox.bottom
            topMargin: 20
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                welcome2Clicked = true;
                secureWebSocket.active = !secureWebSocket.active;
            }
        }
    }
}
