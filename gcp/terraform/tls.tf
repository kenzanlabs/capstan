###
# Your Certificate be is CA signed or SelfSigned
# Of course, it is trivial to get a Let'sEncrypt Wildcard Certificate at this point....cough cough
# expects two files in the same folder 

resource "google_compute_ssl_certificate" "genericwildcard" {
  #this name may be burned into ingress controller for GCE
  name        = "capstantls"
  description = "This is the wildcard certificate to be used in L7 LB Terminiation"
  private_key = "${file("../scripts/private.pem")}"
  certificate = "${file("../scripts/certificate.crt")}"
}
