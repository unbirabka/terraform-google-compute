# Template terraform for create gcp compute instance

## Layout terraform file
```
.
├── terraform-google-compute
    ├── modules
    │   ├── compute-engine-ip
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── compute-engine-noip
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── pubkey
    │   └── id_sekolahlinux.pub
    ├── README.md
    └── sekolahlinux-terraform
        ├── credentials
        │   └── sekolahlinux.json
        ├── main.tf
        └── provisioning
            └── startup_script.sh
```

## How to use terraform gcp template 

* copy **./terraform-google-compute/sekolahlinux-terraform** dengan nama project yang akan dibuat misalkan menjadi **./terraform-google-compute/sekolahlinux-webserver**

* buka **./terraform-google-compute/sekolahlinux-webserver/main.tf** dan rubah value dari paramater `credential` , `project` dan `region` sesuai dengan project yang kalian buat

untuk mendapatkan file `gcp.json` kalian bisa mengunjungi link berikut **[create & manage service account key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)**

```
provider "google" {
  credentials = "${file("./credentials/sekolahlinux.json")}"
  project     = "sekolahlinux-110891"
  region      = "asia-southeast1"
}
```

* buka **./terraform-google-compute/sekolahlinux-webserver/main.tf** dan rubah paramater dibawah sesuai dengan project yang akan dibuat

```
module "compute_engine" {
# pilih module compute-engine-noip jika kamu ingin instance/compute yang kamu buat tanpa public ip
# pilih module compute-engine-ip jika kamu ingin instance/compute yang kamu buat mempunyai public ip
# source = "../modules/compute-engine-noip/"
  source = "../modules/compute-engine-ip/"

  count_compute = 3
  count_start   = 1
  compute_name  = "java-prod"
  compute_type  = "n1-standard-1"
  compute_zones = ["asia-southeast1-a", "asia-southeast1-b", "asia-southeast1-c"]

  tags_network          = ["allow-icmp", "allow-ssh"]
  images_name           = "ubuntu-1604-lts"
  size_root_disk        = 100
  type_root_disk        = "pd-standard"                         //pd-standard or pd-ssd
  startup_script        = "./provisioning/startup_script.sh"
  pub_key_file          = "../pubkey/id_sekolahlinux.pub"
  gce_ssh_user          = "ubuntu"

  compute_labels = {
    "createdby" = "terraform"
    "environment" = "development"
  }
}
```

## Variable
didalam terraform terdapat 3 type  variable yaitu **strings, maps, lists, boolean** detailnya kamu bisa baca di link **[type_variable_terraform](https://www.terraform.io/docs/configuration/variables.html)** , berikut dibawah ini paramater yang harus kamu rubah beserta penjelasannya pada template terraform untuk pembuatan instance di gcp

* **count_compute**
variable **count_compute** digunakan untuk menentukan berapa jumlah instance atau vm yang ingin kamu buat

* **count_start**
variable **count_start** digunakan untuk menentukan dari no berapa nama vm instance yang kita buat dimulai, misal diatas saya memberikan value `1` berarti nanti penamaan akan dimulai dari no 1 contoh `java-prod-1 sampai java-prod-3` namun jika saya memberikan value `3` maka akan dimulai dari `java-prod-3 sampai java-prod-5`

* **compute_name**
variable **compute_name** digunakan untuk menentukan nama dari instance yang akan kita buat

* **compute_type**
variable **compute_type** digunakan untuk menentukan spesifikasi instance yang akan kita set, kalau di aws namanya instance type, kalian bisa melihat list typenya di link berikut **[machine types](https://cloud.google.com/compute/docs/machine-types)**

* **compute_zones**
varibale **compute_zones** digunakan untuk menentukan di zone mana saja compute instance yang akan kamu buat, detail zones nya kamu bisa lihat di link berikut **[regions & zones](https://cloud.google.com/compute/docs/regions-zones/)**

* **tags_network**
variable **tags_network** digunakan untuk memberikan tags yang nantinya digunakan untuk keperluan penentuan firewall yang lebih spesifik ataupun untuk keperluan nat gateway jika kalian menggunakan type network nat instance

* **subnet_network**
variable **subnet_network** digunakan untuk menentukan subnet dari network vpc mana yang akan digunakan pada instance / vm yang kita buat, ingat isi value pada variable ini dengan *subnet* bukan *network*

* **images_name** 
variable **images_name** digunakan untuk menentukan images atau OS apa yang akan kita gunakan pada sebuah instance atau vm yang akan kita buat, untuk list public image kamu bisa lihat di link berikut **[public images](https://cloud.google.com/compute/docs/images#os-compute-support)**

* **size_root_disk**
variable **size_root_disk** digunakan untuk menentukan berapa besar size root storage yang akan digunakan pada sebuah instance atau vm

* **type_root_disk**
variable **type_root_disk** digunakan untuk menentukan type dari root disk yang akan kita gunakan pada vm atau instance yang akan kita buat, disini hanya bisa di isi value `**pd-standard**` atau `**pd-ssd**`

* **startup_script**
variable **startup_script** digunakan untuk menentukan file yang berisikan sheel command yang akan dieksekusi ketika instance tersebut berhasil dibuat dan jalan saat pertama kali

* **pub_key_file**
variable **pub_key_file** digunakan untuk menentukan pubkey ssh mana yang akan di inject atau dipasang ke instane yang akan kita buat di gcp

* **gce_ssh_user**
variable **gce_ssh_user** digunakan untuk menentukan di user ssh apa pubkey akan di inject atau di pasang, jika user yang kamu isi belum terdaftar di os tersebut maka akan dibuatkan user ssh pada vm linux tersebut

* **compute_labels**
variable **compute_labels** digunakan untuk menentukan labels yang akan digunakan pada instance yang akan kita buat, kalau di aws bisa juga disebut tag/tags


## How to run terraform (ikuti urutan dibawah ini untuk eksekusinya)
* **terraform init**

jalankan perintah **terraform init** untuk melakukan download plugin terraform gcp dan juga melakukan mapping terhadap module

* **terraform plan**

jalankan perintah **terraform plan** untuk melihat/mereview template terraform sebelum dilakukan implementasi di gcp

* **terraform apply**

jalankan perintah **terraform apply** untuk mengeksekusi template terraform dan mengimplementasikan ke gcp
