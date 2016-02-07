Router.onBeforeAction ->
  document.title = 'Atlanta Flames Sled Hockey'
  @next()

Router.onAfterAction ->
  if @route.options.title
    document.title = @route.options.title+" - Atlanta Flames Sled Hockey"

Router.map ->
  @route 'home',{
    layoutTemplate: 'layout_index'
    path: '/'
  }

  ###
  #   Contact section
  ###
  # @route 'contactUs',{
  #  title: "Contact Us"
  #  path: '/contact/connect/contact'
  #  template: 'contactUs'
  #  layoutTemplate: 'layout_subclean'
  # }

Router.configure {
  layoutTemplate: 'layout_index'
}
