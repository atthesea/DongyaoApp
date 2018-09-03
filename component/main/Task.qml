import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQml.Models 2.11
import "../common" as COMMON

Page{
    id:taskView

    //任务列表的model
    ListModel{
        id:tasklists
    }

    //任务列表
    ListView {
        id: view
        anchors {
            left: parent.left; top: parent.top; right: parent.right; bottom: parent.bottom;
            margins: 2
        }
        model: visualModel//指向可visualModel(排序后的) 而非 tasklists（未排序的）

        spacing: 4
        cacheBuffer: 50
    }

    DelegateModel {
        id: visualModel

        function lessThan(left, right) {
            //先按照状态排序
            if(left.status < right.status)return true;
            //再按照优先级排序
            if(left.priority > right.priority)return true;
            //再按照id排序
            if(left.id < right.id)return true;

            return false;
        }

        Component.onCompleted:items.setGroups(0, items.count, "unsorted")

        function insertPosition(item) {
            var lower = 0
            var upper = items.count
            while (lower < upper) {
                var middle = Math.floor(lower + (upper - lower) / 2)
                var result = visualModel.lessThan(item.model, items.get(middle).model);
                if (result) {
                    upper = middle
                } else {
                    lower = middle + 1
                }
            }
            return lower
        }

        function sort() {
            while (unsortedItems.count > 0) {
                var item = unsortedItems.get(0)
                var index = insertPosition(item)

                item.groups = "items"
                items.move(item.itemsIndex, index)
            }
        }

        items.includeByDefault: false

        groups: VisualDataGroup {
            id: unsortedItems
            name: "unsorted"
            includeByDefault: true
            onChanged: {
                visualModel.sort()
            }
        }

        model: tasklists

        delegate: TaskDelegate {
            id: delegate
            width: visualModel.width
        }

    }

    function init()
    {

    }

    function updateItems()
    {
        //TODO 更新listmodel

        //重新排序
        visualModel.items.setGroups(0, items.count, "unsorted")
    }
}
