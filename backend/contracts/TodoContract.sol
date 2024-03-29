// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TodoContract {
    event AddTask(address reciepts, uint taskId);
    event DeleteTask(uint taskId, bool isDeleted);
    event EditTask(uint taskId, bool completed);

    struct Task {
        uint id;
        string taskText;
        bool isDeleted;
        bool completed;
    }

    Task[] private tasks;
    mapping (uint => address) taskToOwner;

    // Functions that can be accessed from frontend
    function addTask (string memory taskText, bool isDeleted, bool completed) external {
        uint taskId = tasks.length;
        tasks.push(Task(taskId, taskText, isDeleted, completed));
        taskToOwner[taskId] = msg.sender;
        emit AddTask(msg.sender, taskId);

    }

    function getMyTasks () external view returns (Task[] memory){
        Task[] memory temporary = new Task[](tasks.length);
        uint counter = 0;

        // getting task that is mine and adding to the another array temporary
        for (uint256 i = 0; i < temporary.length; i++) {
            if(taskToOwner[i] == msg.sender && tasks[i].isDeleted == false){
                temporary[counter] = tasks[i];
                counter++;
            }
        }

        // add new temporary array to a new array
        Task[] memory result = new Task[](counter);
        for (uint256 i = 0; i < temporary.length; i++) {
            result[i] = temporary[i];
        }

        return result;
    }

    // update task
    function editTask (uint taskId, bool completed) external {
        if(taskToOwner[taskId] == msg.sender){
            tasks[taskId].completed = completed;
            emit EditTask(taskId, completed);
        }
        
    }

    // delete task
    function deleteTask (uint taskId, bool isDeleted) external {
        if(taskToOwner[taskId] == msg.sender){
            tasks[taskId].isDeleted = isDeleted;
            emit DeleteTask(taskId, isDeleted);
        }
    }


}