# Tomadoc

![logo](/documentation/logo.png)

Aplikasi ini akan menganalisis gambar daun menggunakan model klasifikasi citra yang telah dilatih dengan ribuan data daun tomat sehat maupun terinfeksi. Hasil deteksi akan menampilkan nama penyakit, tingkat keparahan, serta saran perawatan atau pencegahan yang dapat dilakukan pengguna.

## Cara Menyiapkan API
1. Mendownload ngrok
    ```cmd
    npm install -g ngrok
    ```
2. Melakukan cloning github repository
    ```cmd
    git clone https://github.com/Kal2501/tomadoc.git
    ```
3. Masuk ke dalam folder `api`
4. Buat `venv` pada folder tersebut
    ```cmd
    python -m venv venv
    ```
5. Aktifkan `venv`
    ```cmd
    venv\Scripts\activate
    ```
6. Download library yang diperlukan
    ``` cmd
    pip install pip install django djangorestframework tensorflow pillow django-cors-headers
    ```
7. Masuk ke dalam folder `tomadoc_api`
8. Jalankan API
    ```cmd
    python manage.py runserver
    ```
9. Lakukan tunneling server api dengan ngrok
    ```cmd
    ngrok http 8000
    ```
10. Pastikan api dan tuneling sudah berjalan


## Cara Penggunaan Aplikasi

1. Download aplikasi yang ada pada [link berikut]([drive.google.com](https://drive.google.com/file/d/10jXipViHW1gKz716iY3938UHYbfbABAD/view?usp=sharing))
2. Pastikan API sudah dijalankan
3. Melakukan registrasi akun menggunakan username, email, password
    ![sign up](/documentation/regis.jpeg)
4. Melakukan login menggunakan email, dan password
    ![login](/documentation/login.jpeg)
5. Melihat informasi penyakit pada halaman home
    ![home](/documentation/home1.jpeg)
    ![home](/documentation/home2.jpeg)
6. Melihat informasi profile pada halaman profile
    ![profile](/documentation/profile.jpeg)
7. Mengedit profile pada halaman edit profile
    ![profile](/documentation/edit%20profile.jpeg)
8. Mengupload gambar untuk melakukan prediksi penyakit:
    - Mengupload foto yang sudah ada
        ![galery](/documentation/galery.jpeg)
    - Memfoto langsung
        ![profile](/documentation/camera.jpeg)
    - Aplikasi menampikan diagnosis penyakit
        ![diagnosis](/documentation/hasil.jpeg)
