// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick 2.0
import QtWebSockets 1.0

Rectangle {
    width: 360
    height: 360

    function appendMessage(message) {
        messageBox.text += "\n" + message
    }

    // 新增一个客户端列表
    property var clients: []

    WebSocketServer {
        id: server
        listen: true
        port: 8080

        onClientConnected: function(webSocket) {
            // 将新客户端加入列表
            clients.push(webSocket);
            appendMessage(qsTr("Client connected."));

            webSocket.onTextMessageReceived.connect(function(message) {
                // 收到消息后发送给所有客户端
                for (var i = 0; i < clients.length; i++) {
                    if (clients[i] !== webSocket) {
                        clients[i].sendTextMessage(message);
                    }
                }

                appendMessage(qsTr("Server received message: %1").arg(message));
            });
        }

        onErrorStringChanged: {
            appendMessage(qsTr("Server error: %1").arg(errorString));
        }
    }

    // 移除原有 WebSocket 元素，不再需要

    Timer {
        interval: 100
        running: true
        onTriggered: {
            // 不再需要设置 socket.active
        }
    }

    Text {
        id: messageBox
        text: qsTr("Server is running. Clients will receive messages from each other.")
        anchors.fill: parent

        // 移除原有 MouseArea 元素，不再需要
    }
}
