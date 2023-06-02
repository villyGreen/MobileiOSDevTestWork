//
//  SortTypeView.swift
//  TemplateOfDealsViewer
//
//  Created by Green on 31.05.2023.
//

import UIKit

protocol SortTypeViewDelegate: AnyObject {
    func sortTypeViewWillSelectNewSort(_ sortTypeView: SortTypeView,
                                       sortType: SortType,
                                       sortSide: SortSide)
}

enum SortSide: Int {
    case down, up
}

enum SortType: Int, CaseIterable {
    case dateModifierSort
    case instrumentNameSort
    case priceSort
    case amountSort
    case sideSort
    
    var title: String {
        switch self {
        case .dateModifierSort:
            return "Sorted by date of modifier"
        case .instrumentNameSort:
            return "Sorted by instrument name"
        case .priceSort:
            return "Sorted by price"
        case .amountSort:
            return "Sorted by amount"
        case .sideSort:
            return "Sorted by side"
        }
    }
    
}

final class SortTypeView: UIView {
    private let allSortTypes = SortType.allCases
    private let tapButton = UIButton()
    private var menu: UIMenu?
    private var currentSortLabel = UILabel()
    private var upSortButton = UIButton()
    private var downSortButton = UIButton()
    weak var delegate: SortTypeViewDelegate?
    
    var currentSortType: SortType = .dateModifierSort
    var currentSortSide: SortSide = .up
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .systemFill
        layer.cornerRadius = 12
        clipsToBounds = true
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tapButton.frame = CGRect(origin: .zero,
                                 size: CGSize(width: frame.width * 0.8,
                                              height: frame.height))
        currentSortLabel.frame = CGRect(origin: CGPoint(x: 16, y: 0),
                                        size: CGSize(width: frame.width * 0.8,
                                                     height: frame.height))
    }
    
    @objc
    func handleTap(_ sender: UIButton) {
        guard let sortSide = SortSide(rawValue: sender.tag) else { return }
        setSideButtonColor(sortSide)
        currentSortSide = sortSide
        delegate?.sortTypeViewWillSelectNewSort(self,
                                                sortType: currentSortType,
                                                sortSide: sortSide)
    }
    
    private func setupView() {
        addSubview(tapButton)
        
        tapButton.showsMenuAsPrimaryAction = true
        tapButton.menu = UIMenu(children: createMenu())
        addSubview(currentSortLabel)
        currentSortLabel.textColor = .init(white: 0, alpha: 0.5)
        currentSortLabel.text = currentSortType.title
        
        downSortButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        upSortButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        setSideButtonColor(currentSortSide)
        addTargetToSideButton(upSortButton)
        addTargetToSideButton(downSortButton)
        downSortButton.tag = SortSide.down.rawValue
        upSortButton.tag = SortSide.up.rawValue
        
        let buttonStack = UIStackView(arrangedSubviews: [downSortButton, upSortButton])
        buttonStack.axis = .horizontal
        addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: tapButton.trailingAnchor, constant: 16),
            buttonStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            downSortButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setSideButtonColor(_ side: SortSide) {
        UIView.animate(withDuration: 0.3) {
            self.downSortButton.tintColor = .init(white: 0, alpha: side == .down ? 1 : 0.4)
            self.upSortButton.tintColor = .init(white: 0, alpha: side == .down ? 0.4 : 1)
        }
    }
    
    private func addTargetToSideButton(_ button: UIButton) {
        button.addTarget(self,
                         action: #selector(handleTap( _ :)),
                         for: .touchUpInside)
    }
    
    private func createMenu() -> [UIAction] {
        var actions: [UIAction] = []
        let currentIndex = currentSortType.rawValue
        allSortTypes.enumerated().forEach { actions.append(UIAction(title: $1.title,
                                                                    image: currentIndex == $0 ?
                                                                    UIImage(systemName: "checkmark") : nil,
                                                                    attributes: []) { action in
            guard let index = self.allSortTypes.firstIndex(where: { $0.title == action.title }),
                  let sortType = SortType(rawValue: index) else { return }
            self.currentSortType = sortType
            self.refreshMenu()
            self.currentSortLabel.text = action.title
            self.delegate?.sortTypeViewWillSelectNewSort(self,
                                                         sortType: sortType,
                                                         sortSide: self.currentSortSide)
        }) }
        
        return actions
    }
    
    @objc
    private func refreshMenu() {
        menu = nil
        menu = UIMenu(children: createMenu())
        tapButton.menu = menu
        tapButton.showsMenuAsPrimaryAction = true
    }
}


