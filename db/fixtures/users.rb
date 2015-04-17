User.seed(:id,
  { email: 'dylan.cashman@tufts.edu', password: 'dylancashman', admin: true },
  { email: 'dylan.cashman+notadmin@tufts.edu', password: 'dylancashman'}
)
