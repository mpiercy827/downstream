Downstream.start()

Application.ensure_all_started(:mimic)
Mimic.copy(Downstream.Download)

ExUnit.start()
