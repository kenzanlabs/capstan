# This is the topic and subscription that spinnaker will use to hear things from GCR

resource "google_pubsub_topic" "gcr_event_stream" {
  name = "gcr"
}

resource "google_pubsub_subscription" "spinnaker_subscription" {
  name  = "spinnaker"
  topic = "${google_pubsub_topic.gcr_event_stream.name}"
}
