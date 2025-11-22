-- =========================================================
-- LIMPIEZA DE TABLAS (ORDEN POR DEPENDENCIAS)
-- =========================================================

DROP TABLE IF EXISTS public.client_products;
DROP TABLE IF EXISTS public.calendar_events;
DROP TABLE IF EXISTS public.products;
DROP TABLE IF EXISTS public.clients;

-- =========================================================
-- TABLA DE CLIENTES
-- =========================================================

CREATE TABLE public.clients (
  id           BIGSERIAL PRIMARY KEY,
  company_name TEXT NOT NULL,
  person_name  TEXT,
  email        TEXT,
  phone        TEXT,
  UNIQUE (company_name, person_name)
);

-- =========================================================
-- CATALOGO DE PRODUCTOS
-- =========================================================

CREATE TABLE public.products (
  id           BIGSERIAL PRIMARY KEY,
  product_code TEXT UNIQUE NOT NULL,
  name         TEXT NOT NULL,
  category     TEXT,               -- Consultoría, Automatización, Datos, etc.
  description  TEXT,
  base_price   NUMERIC(12,2) NOT NULL,
  billing_type TEXT DEFAULT 'one_time', -- one_time | recurring
  level        TEXT,               -- Básico, Avanzado, etc.
  is_active    BOOLEAN DEFAULT TRUE
);

-- =========================================================
-- TABLA DE EVENTOS DE CALENDARIO
-- (YA LIGADA A CLIENTES MEDIANTE client_id)
-- =========================================================

CREATE TABLE public.calendar_events (
  id BIGSERIAL PRIMARY KEY,
  event_id TEXT UNIQUE NOT NULL,         -- ID interno o de Google Calendar
  summary TEXT NOT NULL,                 -- Título del evento
  start_iso TIMESTAMPTZ NOT NULL,        -- Inicio
  end_iso TIMESTAMPTZ NOT NULL,          -- Fin
  description TEXT,                      -- Detalles
  company_name TEXT,                     -- Empresa asociada (texto libre)
  person_name TEXT,                      -- Persona asociada (texto libre)
  source TEXT DEFAULT 'google_calendar', -- Origen del evento
  calendar_id TEXT DEFAULT 'primary',
  timezone TEXT DEFAULT 'America/Mexico_City',
  status TEXT DEFAULT 'confirmed',
  client_id BIGINT,                      -- Relación con clients.id
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT calendar_events_client_id_fkey
    FOREIGN KEY (client_id) REFERENCES public.clients(id)
);

-- =========================================================
-- TABLA DE PRODUCTOS ADQUIRIDOS POR CLIENTE
-- =========================================================

CREATE TABLE public.client_products (
  id           BIGSERIAL PRIMARY KEY,
  client_id    BIGINT NOT NULL REFERENCES public.clients(id),
  product_code TEXT NOT NULL REFERENCES public.products(product_code),
  company_name TEXT NOT NULL,            -- Texto redundante para consultas rápidas
  person_name  TEXT,
  purchase_date DATE NOT NULL,
  units        INTEGER DEFAULT 1,
  unit_price   NUMERIC(12,2) NOT NULL,
  discount_pct NUMERIC(5,2) DEFAULT 0,
  notes        TEXT
);

-- =========================================================
-- CLIENTES (COINCIDEN CON EMPRESAS QUE QUIERES MANEJAR)
-- =========================================================

INSERT INTO public.clients (company_name, person_name, email, phone) VALUES
-- 1
('Tecnoflex Manufacturing S.A. de C.V.', 'Ing. Daniela Robledo', NULL, NULL),
-- 2
('LogiTrack Solutions', 'Lic. Arturo Méndez', NULL, NULL),
-- 3
('InnovaCorp Business Group', 'Mtra. Verónica Herrera', NULL, NULL),
-- 4
('AgroSmart México', 'MVZ. Luis Pineda', NULL, NULL),
-- 5
('Salud Digital MX', 'Dra. Karla Suárez', NULL, NULL),
-- 6
('RetailMax', 'Lic. Sofía Galindo', NULL, NULL),
-- 7
('EduTech Latam', 'Mtro. Carlos Rivas', NULL, NULL),
-- 8
('TransLogística Integral', 'Ing. Omar Velasco', NULL, NULL),
-- 9
('Hotelera Solaris', 'Lic. Andrea Lara', NULL, NULL),
-- 10
('FinanciaPlus', 'C.P. Ernesto Aguilar', NULL, NULL);

-- =========================================================
-- CATALOGO DE PRODUCTOS (LOS 8 DE TU IMAGEN)
-- =========================================================

INSERT INTO public.products
  (product_code, name, category, description, base_price, billing_type, level)
VALUES
  ('CONSULTORIA_INICIAL',
   'Consultoría Inicial',
   'Consultoría',
   'Sesión de 1 hora para diagnosticar procesos y definir ruta tecnológica.',
   1500.00,
   'one_time',
   'Básico'),

  ('DASHBOARD_INTERACTIVO',
   'Dashboard Interactivo',
   'Inteligencia de Datos',
   'Dashboard personalizado para visualizar KPIs críticos en tiempo real.',
   45000.00,
   'one_time',
   'Avanzado'),

  ('LANDING_PAGE',
   'Desarrollo de Landing Page',
   'Desarrollo Web',
   'Landing optimizada para conversiones con formulario conectado.',
   18000.00,
   'one_time',
   'Intermedio'),

  ('AUTO_BASIC',
   'Paquete de Automatización Básica',
   'Automatización',
   'Automatización de hasta 3 procesos clave para mejorar eficiencia.',
   25000.00,
   'one_time',
   'Básico'),

  ('API_INTEGRATION',
   'Integración de APIs Externas',
   'Integraciones',
   'Conectamos ERPs, CRMs y tiendas para sincronización automática de datos.',
   20000.00,
   'one_time',
   'Intermedio'),

  ('AUTO_ADVANCED',
   'Paquete de Automatización Avanzada',
   'Automatización',
   'Automatiza flujos complejos (cotizaciones → pipeline → facturación).',
   90000.00,
   'one_time',
   'Avanzado'),

  ('TRAINING_TOOLS',
   'Entrenamiento en Herramientas',
   'Capacitación',
   'Sesiones para equipos sobre dashboards y mejores prácticas.',
   2500.00,
   'one_time',
   'Básico'),

  ('MONTHLY_SUPPORT',
   'Soporte Mensual',
   'Servicio Continuo',
   'Monitoreo y mejora continua de automatizaciones y sistemas.',
   8000.00,
   'recurring',
   'Intermedio');

-- =========================================================
-- 50 EJEMPLOS DE COMPRAS (10 CLIENTES x 5 COMPRAS)
-- client_id = orden en que se insertaron los clientes (1..10)
-- =========================================================

INSERT INTO public.client_products
  (client_id, company_name, person_name, product_code, purchase_date,
   units, unit_price, discount_pct, notes)
VALUES
-- Tecnoflex Manufacturing (client_id = 1)
(1, 'Tecnoflex Manufacturing S.A. de C.V.', 'Ing. Daniela Robledo',
 'CONSULTORIA_INICIAL', '2025-01-15', 1, 1500.00, 0, 'Diagnóstico inicial de planta.'),
(1, 'Tecnoflex Manufacturing S.A. de C.V.', 'Ing. Daniela Robledo',
 'AUTO_BASIC',          '2025-02-10', 1, 25000.00, 10, 'Automatización de 3 procesos críticos.'),
(1, 'Tecnoflex Manufacturing S.A. de C.V.', 'Ing. Daniela Robledo',
 'DASHBOARD_INTERACTIVO','2025-03-05', 1, 44000.00, 2, 'Dashboard de producción y scrap.'),
(1, 'Tecnoflex Manufacturing S.A. de C.V.', 'Ing. Daniela Robledo',
 'TRAINING_TOOLS',      '2025-03-20', 3, 2400.00, 4, 'Capacitación al equipo operativo.'),
(1, 'Tecnoflex Manufacturing S.A. de C.V.', 'Ing. Daniela Robledo',
 'MONTHLY_SUPPORT',     '2025-04-01', 1, 8000.00, 0, 'Soporte mensual estándar.'),

-- LogiTrack Solutions (client_id = 2)
(2, 'LogiTrack Solutions', 'Lic. Arturo Méndez',
 'CONSULTORIA_INICIAL', '2025-01-22', 1, 1500.00, 0, 'Diagnóstico de logística.'),
(2, 'LogiTrack Solutions', 'Lic. Arturo Méndez',
 'API_INTEGRATION',     '2025-02-18', 1, 20000.00, 5, 'Integración con WMS y ERP.'),
(2, 'LogiTrack Solutions', 'Lic. Arturo Méndez',
 'DASHBOARD_INTERACTIVO','2025-03-12',1, 45000.00, 0, 'KPIs de entregas a tiempo.'),
(2, 'LogiTrack Solutions', 'Lic. Arturo Méndez',
 'MONTHLY_SUPPORT',     '2025-04-10',1, 7800.00, 2.5,'Plan de soporte con ligera rebaja.'),
(2, 'LogiTrack Solutions', 'Lic. Arturo Méndez',
 'TRAINING_TOOLS',      '2025-04-25',2, 2500.00, 0, 'Workshop para supervisores.'),

-- InnovaCorp Business Group (client_id = 3)
(3, 'InnovaCorp Business Group', 'Mtra. Verónica Herrera',
 'CONSULTORIA_INICIAL','2025-02-03',1,1500.00,0,'Diagnóstico de automatización administrativa.'),
(3, 'InnovaCorp Business Group', 'Mtra. Verónica Herrera',
 'AUTO_BASIC',        '2025-02-20',1,24500.00,2,'Automatización de flujos de aprobación.'),
(3, 'InnovaCorp Business Group', 'Mtra. Verónica Herrera',
 'LANDING_PAGE',      '2025-03-08',1,18000.00,0,'Landing para captación de leads B2B.'),
(3, 'InnovaCorp Business Group', 'Mtra. Verónica Herrera',
 'MONTHLY_SUPPORT',   '2025-03-30',1,8000.00,0,'Soporte para nuevos flujos.'),
(3, 'InnovaCorp Business Group', 'Mtra. Verónica Herrera',
 'DASHBOARD_INTERACTIVO','2025-04-15',1,45500.00, -1,'Dashboard ejecutivo.'),

-- AgroSmart México (client_id = 4)
(4, 'AgroSmart México', 'MVZ. Luis Pineda',
 'CONSULTORIA_INICIAL', '2025-01-10',1,1500.00,0,'Revisión de procesos comerciales.'),
(4, 'AgroSmart México', 'MVZ. Luis Pineda',
 'LANDING_PAGE',        '2025-01-28',1,17500.00,3,'Landing para distribuidores.'),
(4, 'AgroSmart México', 'MVZ. Luis Pineda',
 'API_INTEGRATION',     '2025-02-25',1,20000.00,0,'Integración con CRM agrícola.'),
(4, 'AgroSmart México', 'MVZ. Luis Pineda',
 'TRAINING_TOOLS',      '2025-03-18',2,2500.00,0,'Capacitación fuerza de ventas.'),
(4, 'AgroSmart México', 'MVZ. Luis Pineda',
 'MONTHLY_SUPPORT',     '2025-04-05',1,8200.00, -2,'Soporte con ajuste por inflación.'),

-- Salud Digital MX (client_id = 5)
(5, 'Salud Digital MX', 'Dra. Karla Suárez',
 'CONSULTORIA_INICIAL', '2025-02-05',1,1500.00,0,'Exploración de flujos clínicos.'),
(5, 'Salud Digital MX', 'Dra. Karla Suárez',
 'AUTO_ADVANCED',       '2025-03-01',1,90000.00,5,'Automatización completa de funnel.'),
(5, 'Salud Digital MX', 'Dra. Karla Suárez',
 'DASHBOARD_INTERACTIVO','2025-03-22',1,45000.00,0,'KPIs de pacientes y retención.'),
(5, 'Salud Digital MX', 'Dra. Karla Suárez',
 'MONTHLY_SUPPORT',     '2025-04-01',1,8000.00,0,'Soporte premium.'),
(5, 'Salud Digital MX', 'Dra. Karla Suárez',
 'TRAINING_TOOLS',      '2025-04-20',3,2600.00, -4,'Entrenamiento al staff médico.'),

-- RetailMax (client_id = 6)
(6, 'RetailMax', 'Lic. Sofía Galindo',
 'CONSULTORIA_INICIAL','2025-01-14',1,1500.00,0,'Diagnóstico de tiendas.'),
(6, 'RetailMax', 'Lic. Sofía Galindo',
 'LANDING_PAGE',      '2025-02-02',1,18000.00,0,'Landing para campañas de temporada.'),
(6, 'RetailMax', 'Lic. Sofía Galindo',
 'AUTO_BASIC',        '2025-02-28',1,25000.00,0,'Automatización de reposición.'),
(6, 'RetailMax', 'Lic. Sofía Galindo',
 'DASHBOARD_INTERACTIVO','2025-03-25',1,44000.00,2,'Analítica de ventas.'),
(6, 'RetailMax', 'Lic. Sofía Galindo',
 'MONTHLY_SUPPORT',   '2025-04-18',1,8000.00,0,'Soporte continuo.'),

-- EduTech Latam (client_id = 7)
(7, 'EduTech Latam', 'Mtro. Carlos Rivas',
 'CONSULTORIA_INICIAL','2025-01-18',1,1500.00,0,'Exploración de modelo de suscripción.'),
(7, 'EduTech Latam', 'Mtro. Carlos Rivas',
 'LANDING_PAGE',      '2025-02-05',1,18500.00, -2,'Landing para cursos en línea.'),
(7, 'EduTech Latam', 'Mtro. Carlos Rivas',
 'API_INTEGRATION',   '2025-03-01',1,19500.00,2.5,'Integración con pasarela de pago.'),
(7, 'EduTech Latam', 'Mtro. Carlos Rivas',
 'TRAINING_TOOLS',    '2025-03-15',2,2500.00,0,'Capacitación para equipo de ventas.'),
(7, 'EduTech Latam', 'Mtro. Carlos Rivas',
 'MONTHLY_SUPPORT',   '2025-04-01',1,8000.00,0,'Soporte para iteraciones mensuales.'),

-- TransLogística Integral (client_id = 8)
(8, 'TransLogística Integral', 'Ing. Omar Velasco',
 'CONSULTORIA_INICIAL','2025-02-01',1,1500.00,0,'Diagnóstico de rutas y flota.'),
(8, 'TransLogística Integral', 'Ing. Omar Velasco',
 'API_INTEGRATION',    '2025-02-19',1,20500.00, -2.5,'Integración con GPS y ERP.'),
(8, 'TransLogística Integral', 'Ing. Omar Velasco',
 'AUTO_BASIC',         '2025-03-10',1,25000.00,0,'Automatización de órdenes.'),
(8, 'TransLogística Integral', 'Ing. Omar Velasco',
 'DASHBOARD_INTERACTIVO','2025-03-29',1,45000.00,0,'Dashboard de tiempos de entrega.'),
(8, 'TransLogística Integral', 'Ing. Omar Velasco',
 'MONTHLY_SUPPORT',    '2025-04-12',1,7900.00,1.25,'Soporte con ligero descuento.'),

-- Hotelera Solaris (client_id = 9)
(9, 'Hotelera Solaris', 'Lic. Andrea Lara',
 'CONSULTORIA_INICIAL','2025-01-20',1,1500.00,0,'Evaluación de reservas y CRM.'),
(9, 'Hotelera Solaris', 'Lic. Andrea Lara',
 'LANDING_PAGE',      '2025-02-08',1,18000.00,0,'Landing para reservaciones directas.'),
(9, 'Hotelera Solaris', 'Lic. Andrea Lara',
 'AUTO_BASIC',        '2025-03-02',1,26000.00, -4,'Automatización de emails post-estancia.'),
(9, 'Hotelera Solaris', 'Lic. Andrea Lara',
 'TRAINING_TOOLS',    '2025-03-19',2,2500.00,0,'Capacitación al equipo de recepción.'),
(9, 'Hotelera Solaris', 'Lic. Andrea Lara',
 'MONTHLY_SUPPORT',   '2025-04-07',1,8000.00,0,'Soporte continuo.'),

-- FinanciaPlus (client_id = 10)
(10, 'FinanciaPlus', 'C.P. Ernesto Aguilar',
 'CONSULTORIA_INICIAL','2025-02-07',1,1500.00,0,'Diagnóstico de embudo comercial.'),
(10, 'FinanciaPlus', 'C.P. Ernesto Aguilar',
 'AUTO_ADVANCED',     '2025-03-05',1,89000.00,1,'Automatización de todo el funnel.'),
(10, 'FinanciaPlus', 'C.P. Ernesto Aguilar',
 'DASHBOARD_INTERACTIVO','2025-03-25',1,45000.00,0,'KPIs de captación y conversión.'),
(10, 'FinanciaPlus', 'C.P. Ernesto Aguilar',
 'TRAINING_TOOLS',    '2025-04-10',3,2500.00,0,'Entrenamiento de asesores.'),
(10, 'FinanciaPlus', 'C.P. Ernesto Aguilar',
 'MONTHLY_SUPPORT',   '2025-04-30',1,8200.00, -2,'Soporte mensual con ajuste.');

-- =========================================================
-- EVENTOS EXISTENTES A CLIENTES
-- =========================================================
INSERT INTO public.calendar_events (
  event_id, summary, start_iso, end_iso, description,
  company_name, person_name, source, calendar_id, timezone, status
) VALUES
-- 1. Diagnóstico de automatización para empresa manufacturera
(
  'evt_auto_001',
  'Diagnóstico de procesos y propuesta de automatización',
  '2025-11-25T09:30:00-06:00',
  '2025-11-25T11:00:00-06:00',
  'Primera sesión para analizar los cuellos de botella en la línea de producción, evaluar procesos manuales y mapear oportunidades de automatización mediante software de control y flujos digitales.',
  'Tecnoflex Manufacturing S.A. de C.V.',
  'Ing. Daniela Robledo – Directora de Operaciones',
  'manual',
  'primary',
  'America/Mexico_City',
  'confirmed'
),
-- 2. Implementación de sistema de seguimiento digital
(
  'evt_auto_002',
  'Reunión de implementación del sistema de seguimiento digital',
  '2025-11-27T14:00:00-06:00',
  '2025-11-27T15:30:00-06:00',
  'Sesión técnica para integrar el módulo de trazabilidad digital, capacitar al equipo en dashboards y automatizar la captura de datos de operación.',
  'LogiTrack Solutions',
  'Lic. Arturo Méndez – Jefe de Innovación',
  'manual',
  'primary',
  'America/Mexico_City',
  'confirmed'
),
-- 3. Presentación de resultados de automatización administrativa
(
  'evt_auto_003',
  'Presentación de resultados del piloto de automatización administrativa',
  '2025-12-02T10:00:00-06:00',
  '2025-12-02T11:30:00-06:00',
  'Revisión de métricas del piloto: reducción de tiempos de captura, eliminación de duplicidad de datos, ahorro operativo y propuesta de escalamiento a toda la empresa.',
  'InnovaCorp Business Group',
  'Mtra. Verónica Herrera – Gerente General',
  'manual',
  'primary',
  'America/Mexico_City',
  'confirmed'
);
