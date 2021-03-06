//
//  ImportantViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

class ImportantViewController: UIViewController {
    
    @IBOutlet weak private var addTaskTextField: UITextField!
    
    @IBOutlet weak private var importantTableView: UITableView!
    var listStore: ListStore!
    var taskStore: TaskStore!
    var importantTask: [Task]
    {
        let res = listStore.importantTaskListStore + taskStore.importantTaskTaskStore
        return res
    }
    //combine important tasks in both listStore and taskStore
    override func viewDidLoad() {
        super.viewDidLoad()
        importantTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        importantTableView.reloadData()
        importantTableView.delegate = self
        importantTableView.dataSource = self
        
    }



    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            importantTableView.reloadData()
            let newTask = Task(detail:taskName, taskType: .important, timeCreate: Date())
            taskStore.addTask(task: newTask)
            let index = importantTask.count - 1
            print(index)
            let indexPath = IndexPath(row: index, section: 0)
            importantTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
        }
    }
    
    // MARK: - tap to return
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addTaskTextField.resignFirstResponder()
    }
}

extension ImportantViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importantTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = importantTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.taskStore = taskStore
        cell.initCellForImportantViewController(indexPath: indexPath, listOfImportantTask: importantTask)
        cell.delegate = self
        return cell
    }
}
// MARK: - delegate from UITextField

extension ImportantViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from cell

extension ImportantViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        let indexPath = importantTableView.indexPath(for: cell)
        importantTableView.deleteRows(at: [indexPath!], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
        let indexPath = importantTableView.indexPath(for: cell)
        importantTableView.deleteRows(at: [indexPath!], with: .automatic)
    }
    
    
}
