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
            var randomColor = generateRandomColor();
            messageBox.text = "<font color='" + randomColor + "'>" + message + "</font>\n" + messageBox.text;
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

    TextArea {
        id: messageBox
        anchors.fill: parent
        readOnly: true
        wrapMode: TextEdit.Wrap
        font.pixelSize: 16
        textFormat: TextEdit.RichText
    }

    function generateRandomColor() {
        var letters = '0123456789ABCDEF';
        var color = '#';
        for (var i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }
}
