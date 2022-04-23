install-virtualenv: clean
	python3.9 -m venv venv
	./venv/bin/pip install setuptools pip wheel -U
	./venv/bin/pip install -r requirements.txt
	chmod +x venv/bin/activate
	bash -c "source venv/bin/activate"

clean:
	rm -rf venv

server:
	./venv/bin/python src/manage.py runserver
