//
//  ViewController.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//


import RxCocoa
import RxSwift
import UIKit

final class ViewController: UIViewController {

    // MARK: - Properties
    var viewModel: AccountViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var searchTextField: TintTextField = {
        let tf = TintTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.placeholder = "Enter account name"
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .always
        tf.tintColor = .white
        
        let clearImage = UIImage(systemName: "x.circle.fill")!
        tf.clearButtonWithImage(clearImage)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.font = .systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "mySearchButtonColor")
        return button
    }()
    
    private lazy var searchStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            searchTextField,
            searchButton
        ])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center
        return sv
    }()
    
    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.text = "Total EOS Balance:"
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor(named: "myTextColor")
        return label
    }()
    
    private lazy var totalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            totalTitleLabel,
            totalValueLabel
        ])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        return sv
    }()
    
    private lazy var ramTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.text = "RAM"
        return label
    }()
    
    private lazy var ramValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var cpuTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.text = "CPU"
        return label
    }()
    
    private lazy var cpuValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var netTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.text = "NET:"
        return label
    }()
    
    private lazy var netValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        setupHeirarchy()
        setupLayout()
        bindViewModel()
        
        searchTextField.rx.text.orEmpty
            .map { $0.isValid() }
            .bind(to: searchButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = UIColor(named: "myBackground")
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    private func setupHeirarchy() {
        view.addSubview(searchStackView)
        view.addSubview(containerView)
        containerView.addSubview(accountNameLabel)
        containerView.addSubview(totalStackView)
        containerView.addSubview(ramTitleLabel)
        containerView.addSubview(ramValueLabel)
        containerView.addSubview(cpuTitleLabel)
        containerView.addSubview(cpuValueLabel)
        containerView.addSubview(netTitleLabel)
        containerView.addSubview(netValueLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
                      
            containerView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 48),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    
            accountNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            accountNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            accountNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                        
            totalStackView.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 40),
            totalStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            ramTitleLabel.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 16),
            ramTitleLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            ramTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            ramValueLabel.topAnchor.constraint(equalTo: ramTitleLabel.bottomAnchor, constant: 4),
            ramValueLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            ramValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
           
            cpuTitleLabel.topAnchor.constraint(equalTo: ramValueLabel.bottomAnchor, constant: 16),
            cpuTitleLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            cpuTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            cpuValueLabel.topAnchor.constraint(equalTo: cpuTitleLabel.bottomAnchor, constant: 4),
            cpuValueLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            cpuValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
           
            netTitleLabel.topAnchor.constraint(equalTo: cpuValueLabel.bottomAnchor, constant: 16),
            netTitleLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            netTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            netValueLabel.topAnchor.constraint(equalTo: netTitleLabel.bottomAnchor, constant: 4),
            netValueLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            netValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    private func bindViewModel() {
        viewModel.alertMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.presentAlert(message: $0) })
            .disposed(by: disposeBag)
        
        let response = viewModel.fetchViewModel(trigger: searchButton.rx.tap.asObservable(), text: searchTextField.rx.text.asObservable())
            .flatMapLatest { text in
                self.viewModel.getAccount(text)
                    .retry()
            }
          
        viewModel.accountNameViewModel(account: response)
            .bind(to: accountNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalBalanceViewModel(account: response)
            .bind(to: totalValueLabel.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.netValueViewModel(account: response)
            .bind(to: netValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.ramValueViewModel(account: response)
            .bind(to: ramValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cpuValueViewModel(account: response)
            .bind(to: cpuValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
