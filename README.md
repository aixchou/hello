Build your hello world deb

#prepare

	Ubuntu 18.04
	apt-get install dh-make devscripts
	cat >>~/.bashrc <<EOF
	DEBEMAIL="name@qnap.com"
	DEBFULLNAME="name"
	export DEBEMAIL DEBFULLNAME
	EOF

#clone this sample

	git clone ssh://git@172.17.21.15:10022/misc/my_helloworld.git ${your_project_name}-1.0
	cd ${your_project_name}-1.0
	rm -r .git

#customize

	vi helloworld.c
	dh_make --indep --createorig
	vi debian/control
	#change username description and email
	
#build deb

	dpkg-buildpackage -us -uc
	#make sure everything is fine
	ls ../my_hello*
	#there have 
	./debian/rules clean

#add yml to apply ci flow

	cat << EOF > .gitlab-ci.yml
	stages:
	  -build
	build:
	 image: qne:latest
	 stage: build
	 script:
	   - echo "pre-build"
	   - if [ -f ".gitlab-ci-prebuild.sh" ];then bash .gitlab-ci-prebuild.sh; fi
	   - echo "build"
	   - curl http://172.17.21.15:10080/misc/ci_scripts/raw/0.0.1/build.sh | bash
	   - echo "post-build"
	   - if [ -f ".gitlab-ci-postbuild.sh" ];then bash .gitlab-ci-postbuild.sh; fi
	   - echo "repo"
	   - curl http://172.17.21.15:10080/misc/ci_scripts/raw/0.0.1/repo.sh | bash
	 tags:
	   - shared_runner_docker
	EOF

#push to gitlab

	git init . && git add . && git commit . -m "Init"
