//
//  ViewController.swift
//  4_PriorityQueue
//
//  Created by admin on 2025/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        var queue = PriorityQueue<Int> {
            $0 > $1
        } isEqual: { $0 == $1 }

        queue.enqueue(1)
        queue.enqueue(3)
        queue.enqueue(9)
        queue.enqueue(2)
        queue.enqueue(1)
        queue.enqueue(28)
        queue.enqueue(44)
        queue.enqueue(55)
        queue.enqueue(14)
        
        print("当前最大元素:\(queue.peek()!)")
        print("当前所有元素:\(queue.debugDescription)")
        // 移除最大元素
        let _ = queue.dequeue()
        
        print("当前最大元素:\(queue.peek()!)")
        print("当前所有元素:\(queue.debugDescription)")
       
    }


}

