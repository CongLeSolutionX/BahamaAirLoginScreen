//
//  ViewController.swift
//  BahamaAirLoginScreen
//
//  Created by Cong Le on 12/28/20.
//

import UIKit

// A delay function
func delay(seconds: Double, completion: @escaping ()->Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
  let tint = CASpringAnimation(keyPath: "backgroundColor")
  tint.damping = 5.0
  tint.initialVelocity = -10.0
  tint.fromValue = layer.backgroundColor
  tint.toValue = toColor.cgColor
  tint.duration = tint.settlingDuration
  
  layer.add(tint, forKey: nil)
  layer.backgroundColor = toColor.cgColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
  let round = CASpringAnimation(keyPath: "cornerRadius")
  round.damping = 5.0
  round.fromValue = layer.cornerRadius
  round.toValue = toRadius
  round.duration = round.settlingDuration
  
  layer.add(round, forKey: nil)
  layer.cornerRadius = toRadius
  
  // config the border of textField
  layer.borderWidth = 3.0
  layer.borderColor = UIColor.clear.cgColor  // make transparent border
  
  // flash animation
  let flash = CASpringAnimation(keyPath: "borderColor")
  flash.damping = 7.0
  flash.stiffness = 200.0
  flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
  flash.toValue = UIColor.white.cgColor
  flash.duration = flash.settlingDuration
  
  layer.add(flash, forKey: nil)
}

class ViewController: UIViewController {
  
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
  
  lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.frame = CGRect(x: 0.0,
                         y: loginButton.center.y + 60.0,
                         width: view.frame.size.width,
                         height: 30)
    label.backgroundColor = .clear
    label.font = UIFont(name: "HelveticaNeue", size: 12.0)
    label.textAlignment = .center
    label.textColor = .white
    label.text = "Tap on a field and enter username and password"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
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
  
  lazy var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    spinner.style = .large
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  lazy var cloud1: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bg-sunny-cloud-1.png")
    imageView.alpha = 1.0
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var cloud2: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bg-sunny-cloud-2.png")
    imageView.alpha = 1.0
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
  
  lazy var label: UILabel = {
    let label = UILabel()
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var status: UIImageView = {
    let imageView = UIImageView()
    imageView.isHidden = true
    imageView.image = UIImage(named: "banner")
    imageView.center = loginButton.center
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
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
                        delay(seconds: 2.0) {
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
    completion: { _ in
      /// reset the tint background color and corner radius for login button
      let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
      roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
    }
    )
    
    UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
      // reset the spiner settingss
      self.spinner.center = CGPoint(x: -20.0, y: 16.0)
      self.spinner.alpha = 0.0
      
      // reset the login button settingss
      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      self.loginButton.bounds.size.width -= 80.0
      self.loginButton.center.y -= 60.0
    }, completion: nil
    )
    
    // wobble animation
    let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
    wobble.duration = 0.25
    wobble.repeatCount = 4
    wobble.values = [0.0, -.pi / 4.0, 0.0, .pi / 4.0, 0.0]
    wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
    
    /// If users click on the login button and do not provide credentials into forms, then
    /// perfrom wobble animation for the heading title to remind the users
    heading.layer.add(wobble, forKey: nil)
  }
  
  func animateCloud(layer: CALayer) {
    // calculate the average cloud speed
    let cloudSpeed =  60.0 / Double(view.layer.frame.size.width)
    
    ///calculate the duration for the animation to move the cloud to the right side of the screen
    let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
    
    let cloudMove = CABasicAnimation(keyPath: "position.x")
    cloudMove.duration = duration
    cloudMove.toValue = self.view.bounds.width + layer.bounds.width / 2
    cloudMove.delegate = self
    cloudMove.setValue("cloud", forKey: "name")
    cloudMove.setValue(layer, forKey: "layer")
    
    layer.add(cloudMove, forKey: nil)
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
    animateCloud(layer: cloud1.layer)
    animateCloud(layer: cloud2.layer)
    animateCloud(layer: cloud3.layer)
    animateCloud(layer: cloud4.layer)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    intialFormUIElementsAnimation()
    fadingClouds()
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initialLoginButtonAnimation()
    setupConstraints()
    
    animatingInfoLabel()
    
    username.delegate = self
    password.delegate = self
  }
}

// MARK: - Setup aniamtion for all the UI elements
extension ViewController {
  
  func intialFormUIElementsAnimation() {
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width / 2
    flyRight.toValue = view.bounds.size.width / 2
    flyRight.duration = 0.5 // last for half of a second
    
    // let the CAAnimation instance stay after animated
    flyRight.fillMode = .both
    
    flyRight.delegate = self
    flyRight.setValue("form", forKey: "name")
    flyRight.setValue(heading.layer, forKey: "layer")
    
    heading.layer.add(flyRight, forKey: nil)    // add animation layer to heading label
    flyRight.beginTime = CACurrentMediaTime() + 0.3
    
    flyRight.setValue(username.layer, forKey: "layer")
    username.layer.add(flyRight, forKey: nil)   // add animation layer to username label
    username.layer.position.x = view.bounds.size.width / 2 // set this UI to be on center after animated
    flyRight.beginTime = CACurrentMediaTime() + 0.4
    
    flyRight.setValue(password.layer, forKey: "layer")
    password.layer.add(flyRight, forKey: nil) // add animation layer to password label
    password.layer.position.x = view.bounds.size.width / 2 // set this UI to be on center after animated
    
  }
  
  func animatingInfoLabel() {
    /// slide the infoLabel from the right when the app firsts open
    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = infoLabel.layer.position.x + view.frame.size.width
    flyLeft.toValue = infoLabel.layer.position.x
    flyLeft.duration = 5.0
    
    flyLeft.repeatCount = 2.5
    flyLeft.autoreverses = true
    
    flyLeft.speed = 2.0 // run x2 of the normal speed
    
    // the speed for the layer and nimation run on that layer
    //infoLabel.layer.speed = 2.0 // in this case, aka run x4 time the normal time
   
    
    infoLabel.layer.add(flyLeft, forKey: "infoLabelAppear")
    
    /// Fade in the infoLabel when it slides in
    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    
    infoLabel.layer.add(fadeLabelIn, forKey: "fadeIn")
  }
  
  /// Set up fading efect for clouds
  func fadingClouds() {
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.fromValue = 0.0
    fadeIn.toValue = 1.0
    fadeIn.duration = 0.5
    fadeIn.fillMode = .backwards
    fadeIn.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.add(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.add(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.add(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.add(fadeIn, forKey: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5,
                   initialSpringVelocity: 0.0,
                   animations: {
                    self.loginButton.center.y -= 30.0
                    self.loginButton.alpha = 1.0
                   },
                   completion: nil
    )
  }
  
  /// Use animation group  for the login button
  func initialLoginButtonAnimation() {
    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5
    groupAnimation.fillMode = .backwards
    
    // set easing animationon our animation group as a whole
    groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
    
    
    /// start with a very large version of the button
    /// and, over the course of the animation, shrink it to its normal size.
    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0
    
    /// starts with the layer rotated at a 45-degree angle
    /// and moves it to its normal orientation of zero degrees.
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = .pi / 4.0
    rotate.toValue = 0.0
    
    /// fade-in animation
    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0
    
    /// Add all animation above into the login  button
    groupAnimation.animations = [scaleDown, rotate, fade]
    loginButton.layer.add(groupAnimation, forKey: nil)
  }
  
  func handleLoginButtonTapped() {
    
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
    // Animating the tint background color and corner radius
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
    tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
    roundCorners(layer: loginButton.layer, toRadius: 25.0)

    animatingBalloon()
  }
  
  func animatingBalloon() {
    // Add balloon image layer
    let balloonLayer = CALayer() // since we dont need AutoLayout constraints from UIKit
    let balloonImage = UIImage(named: "balloon") ?? UIImage()
    
    balloonLayer.contents = balloonImage.cgImage
    balloonLayer.frame = CGRect(x: -50.0, y: 0.0, width: 50.0, height: 65.0)
    
    // display the balloon layer underneath other elements
    view.layer.insertSublayer(balloonLayer, below: username.layer)
    
    // flight animation for balloon
    let flight = CAKeyframeAnimation(keyPath: "position")
    flight.duration = 12.0 // is the same at the faux authentication process
    
    /// convert an array of points into an array of points boxed as `NSValues`
    flight.values = [
      CGPoint(x: -50.0, y: 0.0),
      CGPoint(x: view.frame.width + 50.0, y: 160.0),
      CGPoint(x: -50.0, y: loginButton.center.y)
    ].map {NSValue(cgPoint: $0)}
    
    flight.keyTimes = [0.0, 0.5, 1.0]
    
    balloonLayer.add(flight, forKey: nil)
    balloonLayer.position = CGPoint(x: -50.0,
                                    y: loginButton.center.y)
    
    /// Notes:
    /// - Unlike views, layer keyframe animations animate a single property in a continuous animation
    /// over several possible key-points.
    /// - You can animate complex property data types by wrapping them as an `NSValue` type
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
    
    /// when the users tap on the Login button, it will move down and
    /// cover the `infoLabel`
    view.insertSubview(infoLabel, belowSubview: loginButton)
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
      
      // infoLabel
      infoLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
      infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
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
extension ViewController: UITextFieldDelegate {
  @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField.becomeFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let runningAnimation = infoLabel.layer.animationKeys() else { return }
    print(runningAnimation) // print out the active animations running on the label
    
    guard let text = textField.text else { return }
    
    /// Remind the users with jump animation if they input a string less than 5 characters
    if text.count < 5 {
      // jump animation
      let jump = CASpringAnimation(keyPath: "position.y")
      jump.fromValue = textField.layer.position.y + 1.0 // move down 1 point
      jump.toValue = textField.layer.position.y // go back to the original position
      
      jump.initialVelocity = 100.0
      jump.mass = 10.0
      jump.stiffness = 1500.0
      jump.damping = 50.0
      jump.duration = jump.settlingDuration
      
      textField.layer.add(jump, forKey: nil)
      
      // config the border of textField
      textField.layer.borderWidth = 3.0
      textField.layer.borderColor = UIColor.clear.cgColor  // make transparent border
      
      // flash animation
      let flash = CASpringAnimation(keyPath: "borderColor")
      flash.damping = 7.0
      flash.stiffness = 200.0
      flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
      flash.toValue = UIColor.white.cgColor
      flash.duration = flash.settlingDuration
      
      textField.layer.add(flash, forKey: nil)
      
    }
  }
}

// MARK: - Handle the backgound image for View
extension UIView {
  func addBackground(imageName: String?) {
    // screen width and height
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
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
    handleLoginButtonTapped()
  }
}

// MARK: - CAAnimationDelegate
extension ViewController: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard let name = anim.value(forKey: "name") as? String else { return }
    
    // When animation stops, perfrom pulse effect for 0.5 second
    if name == "form" {
      let layer = anim.value(forKey: "layer") as? CALayer
      anim.setValue(nil, forKey: "layer")
      
      let pulse = CASpringAnimation(keyPath: "transform.scale")
      pulse.fromValue = 1.25
      pulse.toValue = 1.0
      
      pulse.damping = 7.5
      // estimates the time required for the system to settle
      pulse.duration = pulse.settlingDuration
      
      // remove the reference to the original layer
      layer?.add(pulse, forKey: nil)
    }
    
    // Repeat animation for the clouds when they stopped
    if name == "cloud" {
      if let layer = anim.value(forKey: "layer") as? CALayer {
        anim.setValue(nil, forKey: "layer")
        
        layer.position.x = -layer.bounds.width / 2
        
        delay(seconds: 0.5) {
          self.animateCloud(layer: layer)
        }
      }
    }
  }
}
