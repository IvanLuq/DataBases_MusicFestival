USE G61_challange2_music_festival;

-- Create table to then store data

DROP TABLE IF EXISTS eurofxref_hist;

CREATE TABLE eurofxref_hist (
    date DATE NOT NULL,
    usd  DECIMAL(10,6),
    jpy  DECIMAL(10,6),
    bgn  DECIMAL(10,6),
    cyp  DECIMAL(10,6),
    czk  DECIMAL(10,6),
    dkk  DECIMAL(10,6),
    eek  DECIMAL(10,6),
    gbp  DECIMAL(10,6),
    huf  DECIMAL(10,6),
    ltl  DECIMAL(10,6),
    lvl  DECIMAL(10,6),
    mtl  DECIMAL(10,6),
    pln  DECIMAL(10,6),
    rol  DECIMAL(10,6),
    ron  DECIMAL(10,6),
    sek  DECIMAL(10,6),
    sit  DECIMAL(10,6),
    skk  DECIMAL(10,6),
    chf  DECIMAL(10,6),
    isk  DECIMAL(10,6),
    nok  DECIMAL(10,6),
    hrk  DECIMAL(10,6),
    rub  DECIMAL(10,6),
    trl  DECIMAL(10,6),
    `try` DECIMAL(10,6),   -- in case it is considered as a function
    aud  DECIMAL(10,6),
    brl  DECIMAL(10,6),
    cad  DECIMAL(10,6),
    cny  DECIMAL(10,6),
    hkd  DECIMAL(10,6),
    idr  DECIMAL(10,6),
    ils  DECIMAL(10,6),
    inr  DECIMAL(10,6),
    krw  DECIMAL(10,6),
    mxn  DECIMAL(10,6),
    myr  DECIMAL(10,6),
    nzd  DECIMAL(10,6),
    php  DECIMAL(10,6),
    sgd  DECIMAL(10,6),
    thb  DECIMAL(10,6),
    zar  DECIMAL(10,6),
    PRIMARY KEY (date)
);


-- Load data
LOAD DATA LOCAL INFILE 'C:/Users/IVANL/Pompeu/3_y/DataBases/Lab2/eurofxref-hist.csv'
INTO TABLE eurofxref_hist
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@date, @usd, @jpy, @bgn, @cyp, @czk, @dkk, @eek, @gbp, @huf, @ltl, @lvl,
 @mtl, @pln, @rol, @ron, @sek, @sit, @skk, @chf, @isk, @nok, @hrk, @rub,
 @trl, @try, @aud, @brl, @cad, @cny, @hkd, @idr, @ils, @inr, @krw, @mxn,
 @myr, @nzd, @php, @sgd, @thb, @zar, @dummy)
SET
  date = STR_TO_DATE(@date, '%Y-%m-%d'),
  usd = NULLIF(@usd, 'N/A'),
  jpy = NULLIF(@jpy, 'N/A'),
  bgn = NULLIF(@bgn, 'N/A'),
  cyp = NULLIF(@cyp, 'N/A'),
  czk = NULLIF(@czk, 'N/A'),
  dkk = NULLIF(@dkk, 'N/A'),
  eek = NULLIF(@eek, 'N/A'),
  gbp = NULLIF(@gbp, 'N/A'),
  huf = NULLIF(@huf, 'N/A'),
  ltl = NULLIF(@ltl, 'N/A'),
  lvl = NULLIF(@lvl, 'N/A'),
  mtl = NULLIF(@mtl, 'N/A'),
  pln = NULLIF(@pln, 'N/A'),
  rol = NULLIF(@rol, 'N/A'),
  ron = NULLIF(@ron, 'N/A'),
  sek = NULLIF(@sek, 'N/A'),
  sit = NULLIF(@sit, 'N/A'),
  skk = NULLIF(@skk, 'N/A'),
  chf = NULLIF(@chf, 'N/A'),
  isk = NULLIF(@isk, 'N/A'),
  nok = NULLIF(@nok, 'N/A'),
  hrk = NULLIF(@hrk, 'N/A'),
  rub = NULLIF(@rub, 'N/A'),
  trl = NULLIF(@trl, 'N/A'),
  `try` = NULLIF(@try, 'N/A'),
  aud = NULLIF(@aud, 'N/A'),
  brl = NULLIF(@brl, 'N/A'),
  cad = NULLIF(@cad, 'N/A'),
  cny = NULLIF(@cny, 'N/A'),
  hkd = NULLIF(@hkd, 'N/A'),
  idr = NULLIF(@idr, 'N/A'),
  ils = NULLIF(@ils, 'N/A'),
  inr = NULLIF(@inr, 'N/A'),
  krw = NULLIF(@krw, 'N/A'),
  mxn = NULLIF(@mxn, 'N/A'),
  myr = NULLIF(@myr, 'N/A'),
  nzd = NULLIF(@nzd, 'N/A'),
  php = NULLIF(@php, 'N/A'),
  sgd = NULLIF(@sgd, 'N/A'),
  thb = NULLIF(@thb, 'N/A'),
  zar = NULLIF(@zar, 'N/A');
