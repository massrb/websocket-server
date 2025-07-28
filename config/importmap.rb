# Pin npm packages by running ./bin/importmap

pin "application"
# pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.16
# pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.0.200
