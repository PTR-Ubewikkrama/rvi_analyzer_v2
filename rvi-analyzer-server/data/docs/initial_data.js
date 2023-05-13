db.group.insertMany([
  {
    'group-id': 'top_admin_group',
    'group-name': 'TOP_ADMIN'
  },
  {
    'group-id': 'admin_group',
    'group-name': 'ADMIN'
  },
  {
    'group-id': 'user_group',
    'group-name': 'USER'
  }
])

db.role.insertMany([
  {
    'role-id': 'login_web',
    'role-name': 'LOGIN_WEB'
  },
  {
    'role-id': 'login_app',
    'role-name': 'LOGIN_APP'
  },
  {
    'role-id': 'create_top_admin',
    'role-name': 'CREATE_TOP_ADMIN'
  },
  {
    'role-id': 'create_admin',
    'role-name': 'CREATE_ADMIN'
  },
  {
    'role-id': 'create_user',
    'role-name': 'CREATE_USER'
  },
  {
    'role-id': 'reset_password',
    'role-name': 'RESET_PASSWORD'
  },//
  {
    'role-id': 'update_device',
    'role-name': 'UPDATE_DEVICE'
  },
  {
    'role-id': 's_mode_one',
    'role-name': 'SAVE_MODE_ONE'
  },
  {
    'role-id': 's_mode_two',
    'role-name': 'SAVE_MODE_TWO'
  },
  {
    'role-id': 's_mode_three',
    'role-name': 'SAVE_MODE_THREE'
  },
  {
    'role-id': 's_mode_four',
    'role-name': 'SAVE_MODE_FOUR'
  },
  {
    'role-id': 's_mode_five',
    'role-name': 'SAVE_MODE_FIVE'
  },
  {
    'role-id': 's_mode_six',
    'role-name': 'SAVE_MODE_SIX'
  },
  {
    'role-id': 'get_mode_one',
    'role-name': 'GET_MODE_ONE'
  },
  {
    'role-id': 'get_mode_two',
    'role-name': 'GET_MODE_TWO'
  },
  {
    'role-id': 'get_mode_three',
    'role-name': 'GET_MODE_THREE'
  },
  {
    'role-id': 'get_mode_four',
    'role-name': 'GET_MODE_FOUR'
  },
  {
    'role-id': 'get_mode_five',
    'role-name': 'GET_MODE_FIVE'
  },
  {
    'role-id': 'get_mode_six',
    'role-name': 'GET_MODE_SIX'
  }
])

db.groupRole.insertMany([
  {
    'group-id': 'top_admin_group',
    'role-ids': [ 'login_web',
    'create_top_admin',
    'create_admin',
    'reset_password',
    'update_device' ]
  },
  {
    'group-id': 'admin_group',
    'role-ids': [ 'login_web',
    'create_user',
    'reset_password',
     'get_mode_one',
     'get_mode_two',
     'get_mode_three',
     'get_mode_four',
     'get_mode_five',
     'get_mode_six' ]
  },
  {
    'group-id': 'user_group',
    'role-ids': [ 'login_app',
    's_mode_one',
    's_mode_two',
    's_mode_three',
    's_mode_four',
    's_mode_five',
    's_mode_six']
  }
])