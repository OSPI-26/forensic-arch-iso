
## Steps to create the iso file
1. clone the `forensic-arch-iso` (in a arch env)

2.  `cd forensic-arch-iso` (You must be in the directory that contains profiledef.sh)

3. Change the github repo username in `configs/forensic/airootfs/root/customize_airootfs.sh`  
(this can be changed in the repo itself since its username is OPCI-26)

4. Create a build output directory `mkdir -p out`
5. remove both work and out folders (inside config/forensics)
    ```
    rm -rf out/ work/
    ```
6. Run mkarchiso 
    ```bash
    mkarchiso -v -r -w work -o out .
    ```
    -v for verbose output

    -r for rebuild everytime

    or
    ```bash
    mkarchiso -w path/to/work_dir -o path/to/out_dir path/to/profile
    ```
7. This iso will then be present in out/

8. Use this iso file in a vm to test it out




