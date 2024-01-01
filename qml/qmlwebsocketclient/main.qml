import QtQuick 2.15
import QtWebSockets 1.0
import QtQuick.Controls 2.15

Rectangle {
    width: 640
    height: 360

    WebSocket {
        id: socket
        url: "ws://192.168.43.1:8083/websocket"
        onTextMessageReceived: function(message) {
            messageBox.text = messageBox.text + "\nReceived message: " + message
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Closed) {
                messageBox.text += "\nSocket closed"
            }
        }
        active: true  // 连接默认是激活的
    }

    Text {
        id: messageBox
        anchors.bottom: parent.bottom
        verticalAlignment: Text.AlignBottom
        visible: true
        color: "red"
        font.pixelSize: 16
        wrapMode: Text.WordWrap
    }
}
