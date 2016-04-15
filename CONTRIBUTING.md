# Contribution Guidelines

- Please submit improvements and bug fixes via GitHub pull requests.

- All patches should have well-written commit message. The first line
  should summarize the change while the rest of the commit message
  should explain the reason the change is needed.

- Please ensure all tests pass before submitting pull requests.

# Testing & Development

This cookbook currently uses mainly [Test Kitchen](https://github.com/chef/test-kitchen) for integration tests.


## Prerequisites

To develop on this cookbook, you must have a sane Ruby 2.0+
environment. Given the nature of this installation process (and it's
variance across multiple operating systems), we will leave this
installation process to the user.

You must also have `bundler` installed:

    $ gem install bundler

You must also have Vagrant and VirtualBox installed:

- [Vagrant](https://vagrantup.com)
- [VirtualBox](https://virtualbox.org)


## Development Workflow
1. Clone the git repository from GitHub:

        $ git clone git@github.com:Shopify/chef-zfs.git

2. Install the dependencies using bundler:

        $ bundle install

3. Create a branch for your changes:

        $ git checkout -b my_bug_fix

4. Make your desired changes.
5. Write tests to support those changes. It is recommended you write
   both unit and integration tests.
6. Run the tests:
    - `bundle exec kitchen test`

7. Assuming the tests pass, open a Pull Request on GitHub.
