/* GCompris - family.qml
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *
 *   RAJDEEP KAUR <rajdeep.kaur@kde.org> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0
import "../../core"
import "family.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "back.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias nodecreator:nodecreator
            property alias answerschoice: answerschoice
            property alias edgecreator: edgecreator
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: partition
            width: background.width
            height: background.height
            Rectangle {
                id:tree
                color: "transparent"
                width: background.width*0.65
                height: background.height
                border.color: "black"
                border.width: 5
                Item {
                    id: treestructure
                    Repeater {
                        id: nodecreator
                        model: ListModel{}
                        delegate:
                            Tree {
                            id: currentpointer
                            x: xx*tree.width
                            y: yy*tree.height
                            width:tree.width/5
                            height:tree.width/5
                            recwidth: currentpointer.width
                            recheight: currentpointer.height
                            searchitem: 3
                            nodeimagesource: Activity.url+nodee
                            nodetextvalue: "sad"
                            bordercolor: "black"
                            borderwidth: 4
                            colorr: "transparent"
                            radius: recwidth/2
                            state:currentstate

                            states : [
                               State {
                                     name:"active"
                                     PropertyChanges {
                                         target: currentpointer
                                         bordercolor:"blue"
                                     }
                               },
                               State {
                                      name:"deactive"
                                      PropertyChanges {
                                          target: currentpointer

                                      }
                               }
                            ]

                            SequentialAnimation {
                                id: anim
                                running:currentpointer.state === "active" ? true : false
                                loops: Animation.Infinite
                                alwaysRunToEnd: true
                                NumberAnimation {
                                    target: currentpointer
                                    property: "rotation"
                                    from: 0; to: 10
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: currentpointer
                                    property: "rotation"
                                    from: 10; to: -10
                                    duration: 400
                                    easing.type: Easing.InOutQuad
                                }
                                NumberAnimation {
                                    target: currentpointer
                                    property: "rotation"
                                    from: -10; to: 0
                                    duration: 200
                                    easing.type: Easing.InQuad
                                }
                            }


                        }

                    }


                    Repeater {
                        id:edgecreator
                        model: ListModel{}
                        delegate: Rectangle {
                            id: edge
                            opacity:1
                            antialiasing: true
                            color:"black"

                            transformOrigin:Item.TopLeft
                            x: x1*tree.width
                            y: y1*tree.height
                            property var x2: x22*tree.width
                            property var y2: y22*tree.height
                            width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                            height: 4 * ApplicationInfo.ratio
                            rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)

                            Behavior on height {
                                NumberAnimation {
                                    duration: 2000
                                    easing.type: Easing.OutExpo
                                }
                            }

                            Behavior on width {
                                NumberAnimation {
                                    duration: 2000
                                    easing.type: Easing.OutExpo
                                }
                            }
                        }
                    }
                }

            }

            Rectangle {
                id: answers
                color: "transparent"
                width: background.width*0.35
                height: background.height
                anchors.left: tree.right
                border.color: "black"
                border.width: 5
                Image {
                    width: parent.width * 0.99
                    height: parent.height * 0.99
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Activity.url + "answerarea.svg"
                    Grid {
                        columns: 1
                        rowSpacing: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        Repeater {
                            id: answerschoice
                            model: ListModel{}
                            delegate:
                                AnswerButton {
                                id: options
                                width: answers.width*0.80
                                height: answers.width*0.25
                                textLabel: optionn
                                onPressed: {
                                    if(textLabel === answer){
                                        bonus.good("lion")
                                    } else {
                                        bonus.bad("lion")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
