//
//  CommentTableViewCell.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/25/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentContainerView: UIView!
    
    
    
    /// CustomCell을 구성합니다.
    /// - Parameter comment: Comment 객체
    func configure(comment: Comment, completion: () -> Void) {
        commentLabel.text = comment.comment
        dateLabel.text = comment.date
        completion()
    }
}
