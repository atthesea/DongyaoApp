#include "bkgimgprovider.h"
#include "global.h"


BkgImgProvider::BkgImgProvider() :QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

QImage BkgImgProvider::requestImage(const QString &id, QSize *size, const QSize& requestedSize)
{
    QImage img;
    auto floor = g_onemap.getFloorById(id.toInt());
    if(floor!=nullptr){
        int bkgId = floor->getBkg();
        auto bkg = g_onemap.getBackgroundById(bkgId);

        if(bkg!=nullptr){
            QByteArray ba(bkg->getImgData(),bkg->getImgDataLen());
            img.loadFromData(ba);
            if(!img.isNull()){
                if (requestedSize.isValid()) {
                    img.scaledToWidth(requestedSize.width());
                    img.scaledToHeight(requestedSize.height());
                }else{
                    img.scaledToWidth(bkg->getWidth());
                    img.scaledToHeight(bkg->getHeight());
                }
                *size = img.size();
            }
        }
    }

    return img;
}

QPixmap BkgImgProvider::requestPixmap(const QString &id, QSize *size, const QSize& requestedSize)
{
    QImage img;
    auto floor = g_onemap.getFloorById(id.toInt());
    if(floor!=nullptr){
        int bkgId = floor->getBkg();
        auto bkg = g_onemap.getBackgroundById(bkgId);

        if(bkg!=nullptr){
            QByteArray ba(bkg->getImgData(),bkg->getImgDataLen());
            img.loadFromData(ba);
            if(!img.isNull()){
                if (requestedSize.isValid()) {
                    img.scaledToWidth(requestedSize.width());
                    img.scaledToHeight(requestedSize.height());
                }else{
                    img.scaledToWidth(bkg->getWidth());
                    img.scaledToHeight(bkg->getHeight());
                }
                *size = img.size();
            }
        }
    }
    QPixmap pix = QPixmap::fromImage(img);
    return pix;
}
