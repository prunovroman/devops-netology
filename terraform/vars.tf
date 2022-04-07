locals {
  instance_type_map = {
      stage = "t2.micro"
      prod = "t2.large"
  }

  instance_count_map = {
      stage = 1
      prod = 2
  }

  instances = {
      stage = { 
          vm1 = "t2.micro"          
        },
      prod = { 
          vm1 = "t2.large",
          vm2 = "t2.large"
        }
  }
}