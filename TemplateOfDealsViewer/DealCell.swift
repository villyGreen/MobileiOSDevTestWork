import UIKit

final class DealCell: UITableViewCell {
  static let reuseIidentifier = "DealCell"
  
  @IBOutlet private weak var instrumentNameLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
  @IBOutlet private weak var amountLabel: UILabel!
  @IBOutlet private weak var sideLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: Deal) {
        priceLabel.text = "\((model.price * 100).rounded() / 100)"
        amountLabel.text = "\(Int(model.amount.rounded()))"
        instrumentNameLabel.text = model.instrumentName
        sideLabel.text = getSideStatus(model.side).sideText
        priceLabel.textColor = getSideStatus(model.side).sideColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateLabel.text = dateFormatter.string(from: model.dateModifier)
    }
    
    private func getSideStatus(_ side: Deal.Side) -> (sideText: String, sideColor: UIColor) {
        switch side {
        case .sell:
            return ("Sell", .red)
        default:
            return ("Buy", .green)
        }
    }

}
