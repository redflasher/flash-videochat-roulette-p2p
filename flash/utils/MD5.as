package utils
{
  public class MD5
  {
    public static function encrypt(data: String): String
    {
      var x:Array;
      var k:uint, AA:uint, BB:uint, CC:uint, DD:uint, a:uint, b:uint, c:uint, d:uint;
      var S11:uint=7, S12:uint=12, S13:uint=17, S14:uint=22;
      var S21:uint=5, S22:uint=9 , S23:uint=14, S24:uint=20;
      var S31:uint=4, S32:uint=11, S33:uint=16, S34:uint=23;
      var S41:uint=6, S42:uint=10, S43:uint=15, S44:uint=21;

      data = u8e(data);

      x = cwa(data);

      a = 0x67452301; b = 0xEFCDAB89; c = 0x98BADCFE; d = 0x10325476;

      for (k = 0; k < x.length; k += 16)
      {
        AA=a; BB=b; CC=c; DD=d;
        a=FF(a,b,c,d,x[k+0], S11,0xD76AA478);
        d=FF(d,a,b,c,x[k+1], S12,0xE8C7B756);
        c=FF(c,d,a,b,x[k+2], S13,0x242070DB);
        b=FF(b,c,d,a,x[k+3], S14,0xC1BDCEEE);
        a=FF(a,b,c,d,x[k+4], S11,0xF57C0FAF);
        d=FF(d,a,b,c,x[k+5], S12,0x4787C62A);
        c=FF(c,d,a,b,x[k+6], S13,0xA8304613);
        b=FF(b,c,d,a,x[k+7], S14,0xFD469501);
        a=FF(a,b,c,d,x[k+8], S11,0x698098D8);
        d=FF(d,a,b,c,x[k+9], S12,0x8B44F7AF);
        c=FF(c,d,a,b,x[k+10],S13,0xFFFF5BB1);
        b=FF(b,c,d,a,x[k+11],S14,0x895CD7BE);
        a=FF(a,b,c,d,x[k+12],S11,0x6B901122);
        d=FF(d,a,b,c,x[k+13],S12,0xFD987193);
        c=FF(c,d,a,b,x[k+14],S13,0xA679438E);
        b=FF(b,c,d,a,x[k+15],S14,0x49B40821);
        a=GG(a,b,c,d,x[k+1], S21,0xF61E2562);
        d=GG(d,a,b,c,x[k+6], S22,0xC040B340);
        c=GG(c,d,a,b,x[k+11],S23,0x265E5A51);
        b=GG(b,c,d,a,x[k+0], S24,0xE9B6C7AA);
        a=GG(a,b,c,d,x[k+5], S21,0xD62F105D);
        d=GG(d,a,b,c,x[k+10],S22,0x2441453);
        c=GG(c,d,a,b,x[k+15],S23,0xD8A1E681);
        b=GG(b,c,d,a,x[k+4], S24,0xE7D3FBC8);
        a=GG(a,b,c,d,x[k+9], S21,0x21E1CDE6);
        d=GG(d,a,b,c,x[k+14],S22,0xC33707D6);
        c=GG(c,d,a,b,x[k+3], S23,0xF4D50D87);
        b=GG(b,c,d,a,x[k+8], S24,0x455A14ED);
        a=GG(a,b,c,d,x[k+13],S21,0xA9E3E905);
        d=GG(d,a,b,c,x[k+2], S22,0xFCEFA3F8);
        c=GG(c,d,a,b,x[k+7], S23,0x676F02D9);
        b=GG(b,c,d,a,x[k+12],S24,0x8D2A4C8A);
        a=HH(a,b,c,d,x[k+5], S31,0xFFFA3942);
        d=HH(d,a,b,c,x[k+8], S32,0x8771F681);
        c=HH(c,d,a,b,x[k+11],S33,0x6D9D6122);
        b=HH(b,c,d,a,x[k+14],S34,0xFDE5380C);
        a=HH(a,b,c,d,x[k+1], S31,0xA4BEEA44);
        d=HH(d,a,b,c,x[k+4], S32,0x4BDECFA9);
        c=HH(c,d,a,b,x[k+7], S33,0xF6BB4B60);
        b=HH(b,c,d,a,x[k+10],S34,0xBEBFBC70);
        a=HH(a,b,c,d,x[k+13],S31,0x289B7EC6);
        d=HH(d,a,b,c,x[k+0], S32,0xEAA127FA);
        c=HH(c,d,a,b,x[k+3], S33,0xD4EF3085);
        b=HH(b,c,d,a,x[k+6], S34,0x4881D05);
        a=HH(a,b,c,d,x[k+9], S31,0xD9D4D039);
        d=HH(d,a,b,c,x[k+12],S32,0xE6DB99E5);
        c=HH(c,d,a,b,x[k+15],S33,0x1FA27CF8);
        b=HH(b,c,d,a,x[k+2], S34,0xC4AC5665);
        a=II(a,b,c,d,x[k+0], S41,0xF4292244);
        d=II(d,a,b,c,x[k+7], S42,0x432AFF97);
        c=II(c,d,a,b,x[k+14],S43,0xAB9423A7);
        b=II(b,c,d,a,x[k+5], S44,0xFC93A039);
        a=II(a,b,c,d,x[k+12],S41,0x655B59C3);
        d=II(d,a,b,c,x[k+3], S42,0x8F0CCC92);
        c=II(c,d,a,b,x[k+10],S43,0xFFEFF47D);
        b=II(b,c,d,a,x[k+1], S44,0x85845DD1);
        a=II(a,b,c,d,x[k+8], S41,0x6FA87E4F);
        d=II(d,a,b,c,x[k+15],S42,0xFE2CE6E0);
        c=II(c,d,a,b,x[k+6], S43,0xA3014314);
        b=II(b,c,d,a,x[k+13],S44,0x4E0811A1);
        a=II(a,b,c,d,x[k+4], S41,0xF7537E82);
        d=II(d,a,b,c,x[k+11],S42,0xBD3AF235);
        c=II(c,d,a,b,x[k+2], S43,0x2AD7D2BB);
        b=II(b,c,d,a,x[k+9], S44,0xEB86D391);
        a=adu(a,AA);
        b=adu(b,BB);
        c=adu(c,CC);
        d=adu(d,DD);
      }

      var temp:String = wth(a)+wth(b)+wth(c)+wth(d);

      return temp.toLowerCase();
    }

    private static function rot_l(val:uint, shb:uint):uint
    {
      return (val<<shb) | (val>>>(32-shb));
    }

    private static function adu(lX:uint, lY:uint):uint
    {
      var lX4:uint ,lY4:uint ,lX8:uint, lY8:uint, res:uint;
      lX8 = (lX & 0x80000000);
      lY8 = (lY & 0x80000000);
      lX4 = (lX & 0x40000000);
      lY4 = (lY & 0x40000000);
      res = (lX & 0x3FFFFFFF) + (lY & 0x3FFFFFFF);
      
      if (lX4 & lY4)
      {
        return (res ^ 0x80000000 ^ lX8 ^ lY8);
      }
      
      if (lX4 | lY4)
      {
        if (res & 0x40000000)
        {
          return (res ^ 0xC0000000 ^ lX8 ^ lY8);
        } else
        {
          return (res ^ 0x40000000 ^ lX8 ^ lY8);
        }
      } else
      {
        return (res ^ lX8 ^ lY8);
      }
    }

    private static function F(x:uint, y:uint, z:uint):uint { return (x & y) | ((~x) & z); }
    private static function G(x:uint, y:uint, z:uint):uint { return (x & z) | (y & (~z)); }
    private static function H(x:uint, y:uint, z:uint):uint { return (x ^ y ^ z); }
    private static function I(x:uint, y:uint, z:uint):uint { return (y ^ (x | (~z))); }

    private static function FF(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, ac:uint):uint
    {
      a = adu(a, adu(adu(F(b, c, d), x), ac));
      return adu(rot_l(a, s), b);
    }

    private static function GG(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, ac:uint):uint
    {
      a = adu(a, adu(adu(G(b, c, d), x), ac));
      return adu(rot_l(a, s), b);
    }

    private static function HH(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, ac:uint):uint
    {
        a = adu(a, adu(adu(H(b, c, d), x), ac));
        return adu(rot_l(a, s), b);
    }

    private static function II(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, ac:uint):uint
    {
      a = adu(a, adu(adu(I(b, c, d), x), ac));
      return adu(rot_l(a, s), b);
    }

    private static function cwa(string:String):Array
    {
      var wcnt:uint;
      var mlen:uint = string.length;
      var wnum_t1:uint = mlen + 8;
      var wnum_t2:uint = (wnum_t1-(wnum_t1 % 64))/64;
      var wnum:uint = (wnum_t2+1)*16;
      var warr:Array = new Array(wnum-1);
      var bpos:uint = 0;
      var bcnt:uint = 0;
      while ( bcnt < mlen )
      {
        wcnt = (bcnt-(bcnt % 4))/4;
        bpos = (bcnt % 4)*8;
        warr[wcnt] = (warr[wcnt] | (string.charCodeAt(bcnt)<<bpos));
        bcnt++;
      }
      wcnt = (bcnt-(bcnt % 4))/4;
      bpos = (bcnt % 4)*8;
      warr[wcnt] = warr[wcnt] | (0x80<<bpos);
      warr[wnum-2] = mlen<<3;
      warr[wnum-1] = mlen>>>29;
      return warr;
    }

    private static function wth(val:uint):String
    {
      var wtv:String = "", wtv_t:String = "", bb:uint, ii:uint;
      for (ii = 0; ii <= 3; ii++)
      {
        bb = (val>>>(ii*8)) & 255;
        wtv_t = "0" + bb.toString(16);
        wtv = wtv + wtv_t.substr(wtv_t.length-2,2);
      }
      return wtv;
    }

    private static function u8e(string:String):String
    {
      var utftext:String = "";

      for (var n:uint = 0; n < string.length; n++)
      {
        var c:uint = string.charCodeAt(n);

        if (c < 128)
        {
          utftext += String.fromCharCode(c);
        }
        else if ((c > 127) && (c < 2048))
        {
          utftext += String.fromCharCode((c >> 6) | 192);
          utftext += String.fromCharCode((c & 63) | 128);
        }
        else
        {
          utftext += String.fromCharCode((c >> 12) | 224);
          utftext += String.fromCharCode(((c >> 6) & 63) | 128);
          utftext += String.fromCharCode((c & 63) | 128);
        }
      }

      return utftext;
 p   }
  }
}