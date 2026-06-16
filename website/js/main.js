// ============================================================================
// Space Code LTDA - Main JavaScript
// ============================================================================

document.addEventListener('DOMContentLoaded', function () {

    // --- Navbar scroll effect ---
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', function () {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // --- Mobile menu toggle ---
    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.querySelector('.nav-links');

    if (menuToggle) {
        menuToggle.addEventListener('click', function () {
            navLinks.classList.toggle('active');
            menuToggle.classList.toggle('active');
        });

        // Close menu on link click
        navLinks.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                navLinks.classList.remove('active');
                menuToggle.classList.remove('active');
            });
        });
    }

    // --- Smooth scroll for anchor links ---
    document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                var offset = navbar.offsetHeight + 20;
                var top = target.getBoundingClientRect().top + window.pageYOffset - offset;
                window.scrollTo({ top: top, behavior: 'smooth' });
            }
        });
    });

    // --- Contact Form Submission ---
    var form = document.getElementById('contactForm');
    var status = document.getElementById('formStatus');

    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();

            var nome = document.getElementById('nome').value.trim();
            var sobrenome = document.getElementById('sobrenome').value.trim();
            var mensagem = document.getElementById('mensagem').value.trim();

            if (!nome || !sobrenome || !mensagem) {
                status.textContent = 'Por favor, preencha todos os campos.';
                status.className = 'form-status error';
                return;
            }

            var data = {
                nome: nome,
                sobrenome: sobrenome,
                mensagem: mensagem,
                data: new Date().toISOString()
            };

            // Send to Python CGI backend
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '/backend/contato.py', true);
            xhr.setRequestHeader('Content-Type', 'application/json');

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var resp = JSON.parse(xhr.responseText);
                            if (resp.status === 'success') {
                                status.textContent = 'Mensagem enviada com sucesso!';
                                status.className = 'form-status success';
                                form.reset();
                            } else {
                                status.textContent = 'Erro: ' + (resp.message || 'Tente novamente.');
                                status.className = 'form-status error';
                            }
                        } catch (err) {
                            status.textContent = 'Mensagem enviada com sucesso!';
                            status.className = 'form-status success';
                            form.reset();
                        }
                    } else {
                        status.textContent = 'Erro ao enviar. Tente novamente.';
                        status.className = 'form-status error';
                    }
                }
            };

            xhr.send(JSON.stringify(data));
        });
    }

    // --- Intersection Observer for animations ---
    var observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Animate cards on scroll
    var cards = document.querySelectorAll('.team-card, .service-card, .feature-card, .info-card');
    cards.forEach(function (card) {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
});
