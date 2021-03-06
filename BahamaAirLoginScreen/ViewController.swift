//
//  ViewController.swift
//  BahamaAirLoginScreen
//
//  Created by Cong Le on 12/28/20.
//

import UIKit

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {
  lazy var loginButton: UIButton = {
    let button = UIButton()
    //    button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
    button.layer.cornerRadius = 8.0
    button.layer.masksToBounds = true
    button.backgroundColor = UIColor(red: 160/255, green: 214/255, blue: 90/255, alpha: 1)
    button.setTitle("Login", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var heading:  UILabel = {
    let label = UILabel()
    label.text = "Bahama Login"
    label.font = UIFont(name: "Helvetica Neue Light", size: 28)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var username: UITextField = {
    let text = UITextField()
    text.placeholder = "Username"
    text.textAlignment = .left
    text.backgroundColor = .white
    text.layer.cornerRadius = 3
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  
  lazy var password: UITextField = {
    let text = UITextField()
    text.placeholder = "Password"
    text.textAlignment = .left
    text.backgroundColor = .white
    text.layer.cornerRadius = 3
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  
  lazy var cloud1: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bg-sunny-cloud-1.png")
    imageView.alpha = 0.0
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var cloud2: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bg-sunny-cloud-2.png")
    imageView.alpha = 0.0
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var cloud3: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bg-sunny-cloud-3.png")
    imageView.alpha = 1.0
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var cloud4: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bg-sunny-cloud-4.png")
    imageView.alpha = 1.0
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    spinner.style = .large
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  lazy var status: UIImageView = {
    let imageView = UIImageView()
    imageView.isHidden = true
    imageView.image = UIImage(named: "banner")
    imageView.center = loginButton.center
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var label: UILabel = {
    let label = UILabel()
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // Properties used for transitioning views
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  var statusPosition = CGPoint.zero
  
}

// MARK: - Transition methods
extension ViewController {
  func showMessage(index: Int) {
    label.text = messages[index]
    label.textColor = .systemRed
    
    UIView.transition(with: status, duration: 0.33,
                      options: [.curveEaseOut, .transitionFlipFromBottom],
                      animations: {
                        self.status.isHidden = false
                      },
                      completion: {_ in
                        /// When the transition completed, wait fro 2 seconds and
                        /// check any any remainning messages.
                        /// If so, remove the current message via `removeMessage(index:)`.
                        /// You then call `showMessage(index:)` in the completion block of `removeMessage(index:)`
                        /// to display the next message in sequence.
                        delay(2.0) {
                          if index < self.messages.count - 1 {
                            self.removeMessage(index: index)
                          } else {
                            self.resetForm()
                          }
                        }
                      }
    )
  }
  
  func removeMessage(index: Int) {
    UIView.animate(
      withDuration: 0.33,
      delay: 0.0,
      options: [],
      animations: {
        self.status.center.x += self.view.frame.size.width
      },
      completion: { _ in
        self.status.isHidden = true
        self.status.center = self.statusPosition
        
        self.showMessage(index: index + 1)
      }
    )
  }
  
  func resetForm() {
    UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop, animations: {
      self.status.isHidden = true
      self.status.center = self.statusPosition
    },
    completion: nil
    )
    
    UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
      // reset the spiner settingss
      self.spinner.center = CGPoint(x: -20.0, y: 16.0)
      self.spinner.alpha = 0.0
      
      // reset the login button settingss
      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      self.loginButton.bounds.size.width -= 80.0
      self.loginButton.center.y -= 60.0
    }, completion: nil)
  }
  
  func animateCloud(cloud: UIImageView) {
    // calculate the average cloud speed
    let cloudSpeed =  60.0 / view.frame.size.width
    
    ///calculate the duration for the animation to move the cloud to the right side of the screen
    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
    
    UIView.animate(
      withDuration: TimeInterval(duration),
      delay: 0.0,
      options: .curveLinear,
      animations: {
        // Moves the cloud to just outside the screen area
        cloud.frame.origin.x = self.view.frame.size.width
      },
      completion: { _ in
        /// move the cloud to just outside the opposite edge of the screen from its current position
        cloud.frame.origin.x = -cloud.frame.size.width
        // re-animates cloud across the screen
        self.animateCloud(cloud: cloud)
        
      }
    )
  }
}
// MARK: - Methods of the view lifecycle
extension ViewController {
  
  override func loadView() {
    super.loadView()
    setupViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //save the banner’s initial position
    statusPosition = status.center
    
    // Animate the clouds
//    animateCloud(cloud: cloud1)
//    animateCloud(cloud: cloud2)
    animateCloud(cloud: cloud3)
    animateCloud(cloud: cloud4)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    /// Place each of the form elements outside the visible bounds of the screen
    heading.center.x  -= view.bounds.width
    username.center.x -= view.bounds.width
    password.center.x -= view.bounds.width
    
    /// set the start position of the button a bit lower on the y-axis
    /// and set its alpha value to zero so that it will start out as invisible.
    loginButton.center.y += 30.0
    loginButton.alpha = 0.0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initialUIElementsAnimation()
    setupConstraints()
  }
}

// MARK: - Setup aniamtion for all the UI elements
extension ViewController {
  
  func initialUIElementsAnimation() {
    /// Animate the form elements onto the screen when the user opens the application
    UIView.animate(withDuration: 1.0) {
      self.heading.center.x += self.view.bounds.width
    }
    
    UIView.animate(withDuration: 1.0,
                   delay: 0.5,
                   options: .curveEaseInOut,
                   animations: {
                    self.username.center.x += self.view.bounds.width
                   },
                   completion: nil
    )
    
    UIView.animate(withDuration: 1.0,
                   delay: 0.7,
                   options: .curveEaseInOut,
                   animations: {
                    self.password.center.x += self.view.bounds.width
                   },
                   completion: nil
    )
    
    /// Fade in all the clouds
    UIView.animate(withDuration: 1.0,
                   delay: 0.9,
                   options: [.repeat, .autoreverse],
                   animations: {
                    self.cloud1.alpha = 1.0
                    self.cloud2.alpha = 1.0
                   },
                   completion: nil
    )
    
    /// Spring animation for the login button
    UIView.animate(withDuration: 3.0,
                   delay: 0.5,
                   usingSpringWithDamping: 0.1,
                   initialSpringVelocity: 1.0,
                   options: .curveEaseInOut,
                   animations: {
                    self.loginButton.center.y -= 30.0
                    self.loginButton.alpha = 1.0
                   },
                   completion: nil
    )
  }
  
  func animateLoginButtonWhenTapped() {
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0.0,
      usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0.0,
      options: [],
      animations: {
        /// Increases the button’s width by 80 points over a duration time
        self.loginButton.bounds.size.width += 80.0
      },
      completion: { _ in
        self.showMessage(index: 0)
      }
    )
    
    UIView.animate(
      withDuration: 0.33,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      options: [],
      animations: {
        /// Moves the button 60 points down when tapped
        self.loginButton.center.y -= 60.0
        
        /// tint the button color to yellow as it moves
        self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        
        /// moves the spinner slightly to the left and fades it in
        self.spinner.center = CGPoint(x: 40.0,
                                      y: self.loginButton.frame.size.height/2)
        self.spinner.alpha = 1.0
      },
      completion: nil
    )
  }
}
// MARK: - Set up views and contraints
extension ViewController {
  
  func setupViews() {
    view.addBackground(imageName: "bg-sunny.png")
    view.addSubview(heading)
    view.addSubview(username)
    view.addSubview(password)
    
    view.addSubview(loginButton)
    loginButton.addSubview(spinner)
    
    view.addSubview(status)
    status.addSubview(label)
    
    view.addSubview(cloud1)
    view.addSubview(cloud2)
    view.addSubview(cloud3)
    view.addSubview(cloud4)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      heading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      heading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      // TextField for Name
      username.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
      username.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      username.heightAnchor.constraint(equalToConstant: 30),
      username.widthAnchor.constraint(equalToConstant: 300),
      
      // TextField for Username
      password.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
      password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      password.heightAnchor.constraint(equalToConstant: 30),
      password.widthAnchor.constraint(equalToConstant: 300),
      
      // Login button
      loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 270),
      loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
      loginButton.heightAnchor.constraint(equalToConstant: 50),
      
      // status image
      status.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
      status.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      status.heightAnchor.constraint(equalToConstant: 50),
      status.widthAnchor.constraint(equalToConstant: 200),
      
      // label
      label.centerXAnchor.constraint(equalTo: status.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: status.centerYAnchor),
      
      // cloud1
      cloud1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
      cloud1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -100),
      
      // cloud2
      cloud2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 105),
      cloud2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      
      // cloud3
      cloud3.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 150),
      cloud3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
      
      // cloud4
      cloud4.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 200),
      cloud4.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
    ])
  }
}

// MARK: - UITextFieldDelegate
extension ViewController {
  @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField.becomeFirstResponder()
    return true
  }
}

// MARK: - Handle the backgound image for View
extension UIView {
  func addBackground(imageName: String?) {
    // screen width and height
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height) )
    guard let safelyImageName = imageName else { return }
    imageViewBackground.image = UIImage(named: safelyImageName)
    
    imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
    
    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
  }
}

// MARK: - Helper methods
extension ViewController {
  
  @objc func loginButtonTapped() {
    view.endEditing(true)
    animateLoginButtonWhenTapped()
  }
}
