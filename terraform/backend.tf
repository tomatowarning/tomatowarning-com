terraform {
  backend "remote" {
    organization = "tomatowarning"

    workspaces {
      prefix = "tomatowarning-com-"
    }
  }
}